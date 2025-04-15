$env.config = {
    completions: { algorithm: "fuzzy" }
    highlight_resolved_externals: true
    keybindings: [
        { modifier: CONTROL, keycode: Char_o, mode: emacs, event: { send: executehostcommand, cmd: "yy" } }
    ]
}
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
$env.EDITOR = 'nvim'

alias ll = ls -l
alias v = nvim
alias lg = lazygit

def st [...args] {
  ssh -t ...$args 'LANG=C.UTF-8 .vim/bin/tmux new -A -s 0'
}

def --env yy [...args] {
    let tmp = (mktemp -t "yazi-cwd.XXXXXX")
    yazi ...$args --cwd-file $tmp
    let cwd = (open $tmp)
    if $cwd != "" and $cwd != $env.PWD {
        cd $cwd
    }
    rm -fp $tmp
}
