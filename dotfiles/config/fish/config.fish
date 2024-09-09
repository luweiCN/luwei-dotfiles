if status is-interactive
    # Commands to run in interactive sessions can go here
end
eval "$($HOME/homebrew/bin/brew shellenv)"

export PATH="$PATH:$(yarn global bin)"
fish_add_path /Applications/WezTerm.app/Contents/MacOS
thefuck --alias | source

alias vim=nvim

set -Ux TMUX_TMPDIR "~/.config/tmux/tmux/default"

# fish_config theme save "Catppuccin Mocha"
# fish_config theme save ays


starship init fish | source
