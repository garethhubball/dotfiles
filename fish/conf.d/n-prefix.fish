#!/bin/fish

set -x N_PREFIX "$HOME/n"

if not contains -- $N_PREFIX/bin "$PATH"
  set PATH "$N_PREFIX/bin:$PATH"
end
