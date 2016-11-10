#!/bin/bash

set -eu

if [ ! -e "$HOME/.vimrc" ]; then
  ln -sf $(git rev-parse --show-toplevel)/dot.vimrc $HOME/.vimrc
fi

if [ ! -e "$HOME/.vim" ]; then
  mkdir -p "$HOME/.vim"
fi

if [ ! -e "$HOME/.vim/filetype.vim" ]; then
  ln -sf $(git rev-parse --show-toplevel)/filetype.vim $HOME/.vim/filetype.vim
fi

if [ ! -e "$HOME/.vim/indent" ]; then
  ln -sfn $(git rev-parse --show-toplevel)/indent $HOME/.vim/indent
fi

if [ ! -e "$HOME/.vim/my_snippets" ]; then
  ln -sfn $(git rev-parse --show-toplevel)/my_snippets $HOME/.vim/my_snippets
fi
