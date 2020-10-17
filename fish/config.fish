set -x PATH "/home/ridecar2/.pyenv/bin" $PATH
status --is-interactive; and pyenv init -| source
status --is-interactive; and pyenv virtualenv-init -| source
