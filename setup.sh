#!/bin/bash

set -eu

if [ ! -e "$HOME/.vim" ]; then
  mkdir -p "$HOME/.vim"
fi

if [ ! -e "$HOME/.vim/vimrc" ]; then
  ln -sf $(git rev-parse --show-toplevel)/dot.vimrc $HOME/.vim/vimrc
fi

if [ ! -e "$HOME/.vim/gvimrc" ]; then
  ln -sf $(git rev-parse --show-toplevel)/dot.gvimrc $HOME/.vim/gvimrc
fi

if [ ! -e "$HOME/.vim/filetype.vim" ]; then
  ln -sf $(git rev-parse --show-toplevel)/filetype.vim $HOME/.vim/filetype.vim
fi

if [ ! -e "$HOME/.vim/indent" ]; then
  ln -sfn $(git rev-parse --show-toplevel)/indent $HOME/.vim/indent
fi
