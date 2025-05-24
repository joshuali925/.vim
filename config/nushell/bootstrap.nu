mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
carapace _carapace nushell | save -f ($nu.data-dir | path join "vendor/autoload/carapace.nu")
zoxide init nushell --no-cmd | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")
