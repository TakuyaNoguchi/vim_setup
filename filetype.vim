augroup filetypedetect
  au BufRead,BufNewFile *.vimrc set filetype=vim
  au BufRead,BufNewFile *.md    set filetype=markdown
  au BufRead,BufNewFile *.json  set filetype=javascript
augroup END
