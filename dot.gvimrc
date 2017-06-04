" カーソルの点滅を止める
set guicursor=a:blinkon0
" メニューバーを非表示にする
set guioptions-=m
" ツールバーを非表示にする
set guioptions-=T
" 左右のスクロールバーを非表示にする
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L
" 水平スクロールバーを非表示にする
set guioptions-=b
" 画面サイズ
set columns=90
set lines=40
" フォントの設定
set guifont=Ricty\ Diminished\ 13.5
" カーソル行を強調表示しない
set nocursorline
" 挿入モードの時のみ、カーソル行をハイライトする
autocmd InsertEnter,InsertLeave * set cursorline!
