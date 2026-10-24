# Copyright (c) 2009 rupa deadwyler. Licensed under the WTFPL license, Version 2

# maintains a jump-list of the directories you actually use
#
# INSTALL:
#     * put something like this in your .bashrc:
#         . /path/to/z.sh
#     * cd around for a while to build up the db
#     * PROFIT!!
#     * optionally:
#         set $_Z_CMD in .bashrc to change the command (default z).
#         set $_Z_DATA in .bashrc to change the datafile (default ~/.z).
#         set $_Z_MAX_SCORE lower to age entries out faster (default 9000).
#         set $_Z_NO_RESOLVE_SYMLINKS to prevent symlink resolution.
#         set $_Z_NO_PROMPT_COMMAND if you're handling PROMPT_COMMAND yourself.
#         set $_Z_EXCLUDE_DIRS to an array of directories to exclude.
#         set $_Z_OWNER to your username if you want use z while sudo with $HOME kept
#
# USE:
#     * z foo     # cd to most frecent dir matching foo
#     * z foo bar # cd to most frecent dir matching foo and bar
#     * z -r foo  # cd to highest ranked dir matching foo
#     * z -t foo  # cd to most recently accessed dir matching foo
#     * z -l foo  # list matches instead of cd
#     * z -e foo  # echo the best match, don't cd
#     * z -c foo  # restrict matches to subdirs of $PWD
#     * z -x      # remove the current directory from the datafile
#     * z -h      # show a brief help message

[ -d "${_Z_DATA:-$HOME/.z}" ] && {
    echo "ERROR: z.sh's datafile (${_Z_DATA:-$HOME/.z}) is a directory."
}

_z() {
    local datafile="${_Z_DATA:-$HOME/.z}" p r t x f now=$EPOCHSECONDS

    # if symlink, dereference
    [ -h "$datafile" ] && datafile=$(readlink "$datafile")

    # bail if we don't own ~/.z and $_Z_OWNER not set
    [ -z "$_Z_OWNER" -a -f "$datafile" -a ! -O "$datafile" ] && return

    # add entries
    if [ "$1" = "--add" ]; then
        shift
        local path="$*" count=0 found='' i lines=()

        # $HOME and / aren't worth matching
        [[ $path = "$HOME" || $path = / ]] && return

        # don't track excluded directory trees
        for x in "${_Z_EXCLUDE_DIRS[@]}"; do [[ $path = "$x"* ]] && return; done

        if [ -f "$datafile" ]; then
            while IFS='|' read -r p r t; do
                x=${r%%.*}; f=${r#"$x"}; f=${f#.}0000
                [[ $t && $x = *[1-9]* && $x$f$t != *[!0-9]* && -d $p ]] || continue
                (( count += 10#$x * 10000 + 10#${f:0:4} ))
                [[ $p = "$path" ]] && found=1 r=$((10#$x + 1))${r:${#x}} t=$now
                x="$p|$r|$t"; lines+=("$x")
            done < "$datafile"
        fi
        [[ $found ]] || { x="$path|1|$now"; lines+=("$x"); }

        # aging, keeping 4 decimals
        if (( count > ${_Z_MAX_SCORE:-9000} * 10000 )); then
            for i in "${!lines[@]}"; do
                p=${lines[i]%|*}; t=${lines[i]##*|}; r=${p##*|}; p=${p%|*}
                x=${r%%.*}; f=${r#"$x"}; f=${f#.}0000; r=$(((10#$x * 10000 + 10#${f:0:4}) * 99 / 100))
                f=000$((r % 10000)); lines[i]="$p|$((r / 10000)).${f: -4}|$t"
            done
        fi
        printf '%s\n' "${lines[@]}" >| "$datafile"
        [ "$_Z_OWNER" ] && chown "$_Z_OWNER:$(id -ng "$_Z_OWNER")" "$datafile"
        return 0

    # tab completion, fills COMPREPLY
    elif [ "$1" = "--complete" ]; then
        COMPREPLY=()
        [ -s "$datafile" ] || return
        local q=${2#* }
        [[ $q = "${q,,}" ]] && x=1
        q=${q// /.*}
        while IFS='|' read -r p r t; do
            if [[ $x ]]; then r=${p,,}; else r=$p; fi
            [[ ( -z $q || $r =~ $q ) && -d $p ]] && COMPREPLY+=("$p")
        done < "$datafile"
        return 0
    fi

    # list/go
    local echo fnd last list opt typ
    while [ "$1" ]; do case "$1" in
        --) while [ "$1" ]; do shift; fnd="$fnd${fnd:+ }$1";done;;
        -*) opt=${1:1}; while [ "$opt" ]; do case ${opt:0:1} in
                c) fnd="^$PWD $fnd";;
                e) echo=1;;
                h) echo "${_Z_CMD:-z} [-cehlrtx] args" >&2; return;;
                l) list=1;;
                r) typ="rank";;
                t) typ="recent";;
                x) if [ -f "$datafile" ]; then
                       local -a lines; mapfile -t lines < "$datafile"
                       for p in "${lines[@]}"; do [[ $p = "$PWD|"* ]] || printf '%s\n' "$p"; done >| "$datafile"
                   fi;;
            esac; opt=${opt:1}; done;;
         *) fnd="$fnd${fnd:+ }$1";;
    esac; last=$1; [ "$#" -gt 0 ] && shift; done
    [ "$fnd" -a "$fnd" != "^$PWD " ] || list=1

    # if we hit enter on a completion just go there
    case "$last" in
        # completions will always start with /
        /*) [ -z "$list" -a -d "$last" ] && builtin cd "$last" && return;;
    esac

    # no file yet
    [ -f "$datafile" ] || return

    local q=${fnd// /.*} lq s best ibest hi=-9999999999 ihi=-9999999999 short common
    local -a mp ip
    lq=${q,,}
    while IFS='|' read -r p r t; do
        if [[ -z $q || $p =~ $q ]]; then s=1; elif [[ ${p,,} =~ $lq ]]; then s=; else continue; fi
        # ranks are compared in hundredths
        x=${r%%.*}; f=${r#"$x"}; f=${f#.}00
        [[ $x && $t && $x$f$t != *[!0-9]* && -d $p ]] || continue
        r=$((10#$x * 100 + 10#${f:0:2}))
        case $typ in
            rank) ;;
            recent) r=$((t - now));;
            # frecency: int(10000 * rank * 3.75 / (0.0001 * age + 1.25))
            *) x=$((now - t + 12500)); (( x > 0 )) || x=1; r=$((r * 3750000 / x));;
        esac
        (( r )) || continue
        x="$r|$p"
        if [[ $s ]]; then
            mp+=("$x"); (( r > hi )) && best=$p hi=$r
        else
            ip+=("$x"); (( r > ihi )) && ibest=$p ihi=$r
        fi
    done < "$datafile"

    # prefer case sensitive
    if [[ $best ]]; then :
    elif [[ $ibest ]]; then best=$ibest mp=("${ip[@]}")
    else return 1
    fi

    # find the common root of the matches, if it exists
    if [[ $list || -z $typ ]]; then
        for x in "${mp[@]}"; do
            p=${x#*|}
            [[ -z $short || ${#p} -lt ${#short} ]] && short=$p
        done
        if [[ $short != / ]]; then
            common=$short
            for x in "${mp[@]}"; do
                [[ ${x#*|} != "$short"* ]] && { common=; break; }
            done
        fi
    fi

    if [ "$list" ]; then
        [ "$common" ] && printf "%-10s %s\n" "common:" "$common" >&2
        for x in "${mp[@]}"; do
            r=${x%%|*}
            [ "$typ" = rank ] && printf -v r '%d.%02d' $((r / 100)) $((r % 100))
            printf "%-10s %s\n" "$r" "${x#*|}"
        done | sort -n >&2
    else
        [ "$common" ] && best=$common
        if [ "$echo" ]; then echo "$best"; else builtin cd "$best"; fi
    fi
}

_z_complete() { _z --complete "$COMP_LINE"; }
complete -o filenames -F _z_complete ${_Z_CMD:-z}

[ "$_Z_NO_PROMPT_COMMAND" ] || {
    # populate directory list, resolving symlinks without a subshell unless the path has one
    _z_prompt() {
        [[ $PWD != "$_z_last_pwd" ]] || return; _z_last_pwd=$PWD
        local p=$PWD d=$PWD
        if [ -z "$_Z_NO_RESOLVE_SYMLINKS" ]; then
            while [[ $d ]]; do [[ -h $d ]] && { p=$(command pwd -P 2>/dev/null); break; }; d=${d%/*}; done
        fi
        _z --add "$p"
    }
    [[ $PROMPT_COMMAND = *_z_prompt* ]] || PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }_z_prompt"
}
