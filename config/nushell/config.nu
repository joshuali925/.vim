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
        cmd: "ls | each { |row| $row.name } | input list --fuzzy ' ' | if $in != null { if ($in | path type) == dir { cd $in } else { ^$env.EDITOR $in } }"
      }
    }
    {
      modifier: CONTROL
      keycode: Char_p
      mode: emacs
      event: {
        send: executehostcommand
        cmd: "rg --files | lines | input list --fuzzy ' ' | if $in != null { commandline edit --append $in; commandline set-cursor --end }"
      }
    }
  ]
}
$env.PATH = ($env.PATH | split row (char esep) | prepend ["~/.local/bin" "~/.local/lib/node-packages/bin" "~/.local/share/mise/shims" "~/.local/share/nvim/mason/bin"])
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
$env.EDITOR = 'nvim'

alias ll = ls -al
alias v = ^$env.EDITOR
alias lg = lazygit
alias size = du | sort-by apparent | reverse

alias gd = git diff
alias gpf = git push --force-with-lease fork (git symbolic-ref --short HEAD)
alias gl = git pull
alias glo = git log --graph --pretty=simple
alias gloo = git log --graph --pretty=simple --max-count 15
alias gs = git status
alias gco = git checkout

def st [...args] {
  ssh -t ...$args 'LANG=C.UTF-8 .vim/bin/tmux new -A -s 0'
}

def vf [] {
  rg --files | lines | input list --fuzzy ' ' | if $in != null { ^$env.EDITOR $in }
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

def --env yy [...args] {
  let tmp = (mktemp -t "yazi-cwd.XXXXXX")
  yazi ...$args --cwd-file $tmp
  let cwd = (open $tmp)
  if $cwd != "" and $cwd != $env.PWD {
      cd $cwd
  }
  rm -fp $tmp
}
