set -o vi
bind -m vi-command '"\C-l": clear-screen'
bind -m vi-insert  '"\C-l": clear-screen'

source $HOME/.bashfucs
# if [ -z "$TMUX" ] && [ -z "$SSH_TTY" ]; then ... fi
