$env.config = {
  completions: { algorithm: "fuzzy" }
  highlight_resolved_externals: true
  keybindings: [
    { modifier: CONTROL, keycode: Char_o, mode: emacs, event: { send: executehostcommand, cmd: yy } }
    { modifier: CONTROL, keycode: Char_7, mode: emacs, event: { edit: Undo } }  # C-/ for undo
    {
      modifier: ALT
      keycode: Char_c
      mode: emacs
      event: {
        send: executehostcommand
        cmd: "let sel = (ls | each { |row| $row.name } | input list --fuzzy ' '); if $sel != null { if (commandline | is-empty) { if ($sel | path type) == dir { cd $sel } else { ^$env.EDITOR $sel } } else { commandline edit --insert $'(($sel | to nuon)) ' } }"
      }
    }
    {
      modifier: CONTROL
      keycode: Char_p
      mode: emacs
      event: {
        send: executehostcommand
        cmd: "rg --files | lines | input list --fuzzy ' ' | if $in != null { commandline edit --insert $'(($in | to nuon)) ' }"
      }
    }
  ]
}
$env.PATH = ($env.PATH | split row (char esep) | prepend ["~/.local/bin" "~/.local/lib/node-packages/bin" "~/.local/share/mise/shims" "~/.local/share/nvim/mason/bin"])
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
$env.EDITOR = 'nvim'

alias ll = ls -al
alias v = ^$env.EDITOR
alias vi = vim
alias vim = ^$env.EDITOR
alias lg = lazygit
alias size = du | sort-by apparent | reverse

alias g = git log --graph --pretty=simple --boundary --max-count 15
alias gaa = git add --all
alias gcl = git clone --filter=blob:none
alias gco = git checkout
alias gcm = git checkout main
alias gd = git diff
alias gdst = git diff --staged
alias gf = git fetch
alias gl = git pull
alias glo = git log --graph --pretty=simple
alias gpf = git push --force-with-lease fork (git symbolic-ref --short HEAD)
alias gr = git remote
alias grv = git remote -v
alias gs = git status
alias gst = git stash

def gc [...message: string] {
    git commit -m ($message | str join " ")
}

def --wrapped st [...args] {
  ssh -t ...$args 'LANG=C.UTF-8 EDITOR=nvim PATH=$HOME/.local/bin:$PATH:$HOME/.vim/bin .vim/bin/tmux new -A -s 0'
}

def --wrapped rclone [...args] {
  with-env { RCLONE_PROGRESS: "true", RCLONE_DELETE_EMPTY_SRC_DIRS: "true", RCLONE_DISABLE_HTTP2: "true", RCLONE_MULTI_THREAD_CUTOFF: "1Mi" } { ^rclone ...$args }
}

def --env --wrapped z [...args] {
  if ($args | is-empty) {
    cd $'(zoxide query --exclude $env.PWD --list | lines | input list --fuzzy " ")'
  } else {
    cd $'(zoxide query --exclude $env.PWD -- ...$args | str trim -r -c "\n")'
  }
}

def vf [] {
  let sel = (rg --files | lines | input list --fuzzy ' ')
  if $sel != null { ^$env.EDITOR $sel }
}

def untildone [command: string, --interval: duration = 1sec, --max-tries: int = 0] {
  mut try = 1
  loop {
    print $"Try ($try) at (date now)"
    try {
      nu -c $command
      break
    }
    if $max_tries > 0 and $try >= $max_tries {
      print $"Max tries ($max_tries) reached. Exiting."
      break
    }
    $try = $try + 1
    sleep $interval
  }
}

def sftp-get [host: string, path: string] {
  while (do -i { $'reget -rp "($path)"' | ^sftp $host; $env.LAST_EXIT_CODE }) != 0 { sleep 1sec }
}

def sftp-put [host: string, path: string] {
  let local = ($path | path expand)
  let is_dir = (($local | path type) == 'dir')
  let fwd = {|p| $p | str replace --all '\' '/' }
  let root = ($local | path basename)
  let files = ((if $is_dir { glob ((do $fwd $local) + '/**/*') | where {|p| ($p | path type) == 'file' } } else { [$local] }) | each {|p| { l: (do $fwd $p), r: (if $is_dir { $'($root)/(do $fwd ($p | path relative-to $local))' } else { $root }), size: (ls -D $p | get 0.size | into int) } })
  loop {
    let probe_in = (($files | each {|f| $f.r } | str join (char newline)) + (char newline))
    let sizes = ($probe_in | ^ssh -o StrictHostKeyChecking=accept-new $host 'while IFS= read -r p; do d=${p%/*}; [ "$d" != "$p" ] && mkdir -p "$d"; printf "%s\t%s\n" "$(stat -c %s "$p" 2>/dev/null || echo -1)" "$p"; done' | complete | get stdout | lines | where {|l| $l != '' } | each {|l| let x = ($l | split row -n 2 "\t"); { r: $x.1, size: ($x.0 | into int) } })
    let todo = ($files | each {|f|
        let rs = ($sizes | where r == $f.r | get size? | get 0? | default (-1))
        { l: $f.l, r: $f.r, cmd: (if $rs == $f.size { null } else if ($rs > 0 and $rs < $f.size) { 'put -a' } else { 'put' }) }
      } | where cmd != null)
    if ($todo | is-empty) { break }
    try { ((['progress'] | append ($todo | each {|t| $'($t.cmd) "($t.l)" "($t.r)"' }) | str join (char newline)) + (char newline)) | ^sftp -b - -o StrictHostKeyChecking=accept-new $host }
    sleep 1sec
  }
}

def --env --wrapped yy [...args] {
  let tmp = (mktemp -t "yazi-cwd.XXXXXX")
  ^yazi ...$args --cwd-file $tmp
  let cwd = (open $tmp)
  if $cwd != "" and $cwd != $env.PWD {
    cd $cwd
  }
  rm -fp $tmp
}
