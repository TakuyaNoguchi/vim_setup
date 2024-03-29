" vim内部で使われる文字エンコーディングをutf-8に設定する
set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8 " 保存時の文字コード
" 色付けの設定
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
" 全角記号の表示に関する設定
set ambiwidth=double
" 読み込み時の文字コードの自動判別. 左側が優先される
set fileencodings=ucs-boms,utf-8,euc-jp,cp932
set fileformats=unix,dos,mac " 改行コードの自動判別. 左側が優先される
set history=1000
set wildmenu " コマンドモードの補完
set history=5000 " 保存するコマンド履歴の数
set whichwrap=b,s,h,l,<,>,[,] " カーソルを行頭、行末で止まらないようにする
" yankでクリップボートにコピーする
set clipboard&
set clipboard^=unnamedplus
" カレントディレクトリを開いているファイルのディレクトリに自動的に切り替える
set autochdir
" Insertモード内でpasteモードへの切り替えを行う(Normalモードにもキーバインドは反映される)
" 「F12 -> Ctrl-Shift-v」のように入力して貼り付けることを想定
set pastetoggle=<F12>
" swapファイルを生成しない
set noswapfile
" BackSpace、Deleteを有効化
set backspace=indent,eol,start
" インデントの設定
set autoindent
set smartindent
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
" ESCの反応に関する設定
set notimeout
set ttimeout
set ttimeoutlen=0
" カーソル後の文字削除
inoremap <silent> <C-d> <Del>
" バックアップファイルを作成しない
set nobackup
" 検索ワードのハイライトを有効(C-l, C-hで一解除)
set hlsearch
nnoremap <silent> <C-h> :<C-u>nohlsearch<CR>
" escをC-kに割り当てる
cnoremap <C-k> <esc>
inoremap <C-k> <esc>
vnoremap <C-k> <esc>
" 括弧のハイライトを消す
let loaded_matchparen = 1
" ハイライトを有効化する
syntax enable
" ステータスラインの表示のために必要
set laststatus=2
set t_Co=256
" コメント行の改行時にコメントアウトが継続されてしまうのを防ぐ
augroup auto_comment_off
    autocmd!
    autocmd BufEnter * setlocal formatoptions-=r
    autocmd BufEnter * setlocal formatoptions-=o
augroup END

" カーソル位置を記憶する
autocmd BufReadPost *
      \ if line("'\"") > 0 && line ("'\"") <= line("$") |
      \   exe "normal! g'\"" |
      \ endif

" 1つ前に実行したコマンドを実行する
nnoremap c. q:k<CR>

" バッファの移動を楽にする
nnoremap <silent> gp :bprevious<CR>
nnoremap <silent> gn :bnext<CR>
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>

" コマンドラインモードのキーバインドをEmacsに
cnoremap <C-A> <Home>
cnoremap <C-B> <Left>
cnoremap <C-D> <Del>
cnoremap <C-E> <End>
cnoremap <C-F> <Right>
cnoremap <C-N> <Down>
cnoremap <C-P> <Up>
cnoremap <Esc><C-B> <S-Left>
cnoremap <Esc><C-F> <S-Right>

" 削除キーでyankしない
nnoremap x "_x
nnoremap d "_d
nnoremap D "_D

" IMEをノーマルモードに切り替わる時にOFFにする
if executable('fcitx-remote')
  function! Fcitx2en()
    let l:a = system("fcitx-remote -c")
  endfunction
  autocmd InsertLeave * call Fcitx2en()
endif

" Ruby, JSのファイルを編集する際は行末の空白を削除する
autocmd BufWritePre *.rb call DeleteLastSpace()
autocmd BufWritePre *.js call DeleteLastSpace()
function! DeleteLastSpace()
    let save_cursor = getpos('.')
    silent exec 'retab'
    silent exec '%s/ \+$//e'
    call setpos(".", save_cursor)
endfunction

" 参考サイト(http://postd.cc/how-to-boost-your-vim-productivity/)
" Leaderの設定(デフォルトは\)
let mapleader = "\<Space>"
" よく使うコマンド
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
" Visual Mode のよく使う操作を Space + キーで行う
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P
" Visual Line Mode に切り替え
nmap <Leader><Leader> V
" ファイルの先頭、末尾への移動を楽にする
nnoremap <CR> G
nnoremap <BS> gg
" 貼り付け時にペーストバッファが上書きされないようにする
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction
function! s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()


" -------------------------------
" vim-plug
" -------------------------------
call plug#begin('~/.vim/plugged')

if has('nvim')
  " 補完を行うプラグイン
  Plug 'neoclide/coc.nvim', { 'branch': 'release', 'do': 'yarn install --frozen-lockfile' }
else
  Plug 'Shougo/neocomplete.vim'
  Plug 'Konfekt/FastFold'
endif

" タグ生成
Plug 'szw/vim-tags'

Plug 'vim-ruby/vim-ruby'

" Rubyのブロックを対象にするテキストオブジェクト(r)を追加する
" dir でブロックを削除、yir でブロックをヤンクなど
Plug 'kana/vim-textobj-user'
Plug 'rhysd/vim-textobj-ruby'

" endの自動補完
Plug 'tpope/vim-endwise'

" カーソル移動を楽にする(ace-jump-mode のようなもの)
Plug 'Lokaltog/vim-easymotion'

" % で対応する括弧に移動する機能を拡張
Plug 'tmhedberg/matchit'

" 最近開いたファイルを表示
"Plug 'Shougo/neomru.vim'

" Railsのファイル移動を楽にする
Plug 'Shougo/unite.vim'
Plug 'basyura/unite-rails'

" Rails向けのコマンドを提供する
Plug 'tpope/vim-rails'

" シングルクオートとダブルクオートの入れ替え等
Plug 'tpope/vim-surround'

" 行末の半角スペースを可視化
Plug 'bronson/vim-trailing-whitespace'

" vimでemmetを使用する
Plug 'mattn/emmet-vim'

" 括弧の入力を楽にする
Plug 'kana/vim-smartinput'

" JavaScript
Plug 'pangloss/vim-javascript'
Plug 'mattn/jscomplete-vim'

" JavaScriptのインデント
Plug 'jiangmiao/simple-javascript-indenter'

" JavaScriptの色付け
Plug 'jelera/vim-javascript-syntax'

" VimでPerl、Rubyの正規表現を使用する(置換は %S を使用することで利用可能)
Plug 'othree/eregex.vim'

" 整形を楽に行うためのプラグイン
Plug 'junegunn/vim-easy-align'

" htmlに関するプラグイン
Plug 'othree/html5.vim'

" Sassに関するプラグイン
Plug 'cakebaker/scss-syntax.vim'

" YAMLに関するプラグイン
Plug 'mrk21/yaml-vim'

" コードの静的解析ツール
Plug 'scrooloose/syntastic'

" ステータスラインの表示を変更
Plug 'itchyny/lightline.vim'

" ColorScheme
Plug 'jpo/vim-railscasts-theme'
call plug#end()

" ここに記述しないとプラグインのインデントが上手く動作しない
filetype plugin indent on

if !has('nvim')
  " --------------------------------
  " neocomplete.vim
  " --------------------------------
  let g:acp_enableAtStartup = 0
  " 起動時に有効化
  let g:neocomplete#enable_at_startup = 1
  " 大文字が入力されるまで大文字と小文字の区別を無視する
  let g:neocomplete#enable_smart_case = 1
  " _(アンダースコア)区切りの補完を有効化
  let g:neocomplete#enable_underbar_completion = 1
  let g:neocomplete#enable_camel_case_completion  =  1
  " ポップアップメニューで表示される候補の数
  let g:neocomplete#max_list = 20
  if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
  endif
  let g:neocomplete#auto_completion_start_length = 1
  let g:neocomplete#sources#buffer#cache_limit_size = 500000
  let g:neocomplete#data_directory = $HOME.'/.vim/cache/neocompl'
  let g:neocomplete#min_keyword_length = 3
  let g:neocomplete#enable_refresh_always = 1
  if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
  endif

  let g:neocomplete#keyword_patterns['default'] = '\h\w*'
  call neocomplete#custom#source('_', 'converters',
        \ ['converter_remove_overlap', 'converter_remove_last_paren',
        \  'converter_delimiter', 'converter_abbr'])

  " filetype=ruby で tag 補完を無効にする
  call neocomplete#custom#source('tag',
        \ 'disabled_filetypes', {'ruby' : 1})

  " Plugin key-mappings.
  inoremap <expr><C-g>     neocomplete#undo_completion()

  " Recommended key-mappings.
  " <CR>: close popup and save indent.
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function()
          return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
          " For no inserting <CR> key.
          "return pumvisible() ? "\<C-y>" : "\<CR>"
  endfunction

  " <TAB>: completion.
  inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
endif

" --------------------------------
" emmet-vim
" --------------------------------
" [Document](https://github.com/mattn/emmet-vim/blob/master/doc/emmet.txt)
" 言語を日本語に設定
let g:user_emmet_settings = {
    \    'variables': {
    \      'lang': "ja"
    \    },
    \   'indentation': '  '
    \ }

" --------------------------------
" vim-easymotion の設定
" --------------------------------
" デフォルトのマッピングはOFF
let g:EasyMotion_do_mapping = 0
" ホームポジションに近いキーを使う
let g:EasyMotion_keys='hjklasdfgyuiopqwertnmzxcvbHJKLASDFGYUIOPQWERTNMZXCVB'
" 1 ストローク選択を優先する
let g:EasyMotion_grouping=1
" 大文字と小文字を区別しない
let g:EasyMotion_smartcase = 1
" カラー設定変更
hi EasyMotionTarget ctermbg=none ctermfg=red
hi EasyMotionShade  ctermbg=none ctermfg=blue

map f <Plug>(easymotion-fl)
map t <Plug>(easymotion-tl)
map F <Plug>(easymotion-Fl)
map T <Plug>(easymotion-Tl)
map s <Plug>(easymotion-s2)

" j で現在行以降、k で現在行以前を対象に検索
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" :h easymotion-command-line
nmap g/ <Plug>(easymotion-sn)
xmap g/ <Plug>(easymotion-sn)
omap g/ <Plug>(easymotion-tn)

""""""""""""""""""""""""""""""
" Unite.vimの設定
""""""""""""""""""""""""""""""
" http://blog.remora.cx/2010/12/vim-ref-with-unite.html
" 入力モードで開始する
let g:unite_enable_start_insert=1
" 大文字小文字を区別しない
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1

nnoremap <silent> ,ub   :<C-u>Unite buffer<CR>
nnoremap <silent> ,ul   :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> ,ur   :<C-u>Unite file_mru buffer<CR>
nnoremap <Leader>r      :<C-u>Unite file_mru buffer<CR>
nnoremap <silent> ,uf   :<C-u>Unite file/new<CR>
nnoremap <silent> ,ud   :<C-u>Unite directory/new<CR>
nnoremap <silent> ,ug   :<C-u>Unite grep:. -buffer-name=search-buffer<CR>
nnoremap <silent> ;us   :<C-u>Unite file_rec/async:!<CR>

" よく使うコマンドをLeader(Space)との組み合わせで実行できるように設定
nmap <Leader>b :<C-u>Unite buffer<CR>
nmap <Leader>d :<C-u>Unite directory/new<CR>
nmap <Leader>f :<C-u>Unite file/new<CR>

""""""""""""""""""""""""""""""
" unite-railsの設定
""""""""""""""""""""""""""""""
noremap ,rc :<C-u>Unite rails/controller<CR>
noremap ,rm :<C-u>Unite rails/model<CR>
noremap ,rv :<C-u>Unite rails/view<CR>
noremap ,rh :<C-u>Unite rails/helper<CR>
noremap ,rs :<C-u>Unite rails/stylesheet<CR>
noremap ,rj :<C-u>Unite rails/javascript<CR>
noremap ,rr :<C-u>Unite rails/route<CR>
noremap ,rg :<C-u>Unite rails/gemfile<CR>
noremap ,rt :<C-u>Unite rails/spec<CR>
noremap ,rd :<C-u>Unite rails/db<CR>
noremap ,ro :<C-u>Unite rails/config<CR>

" よく使うコマンドをLeader(Space)との組み合わせで実行できるように設定
nmap <Leader>c :<C-u>Unite rails/controller<CR>
nmap <Leader>m :<C-u>Unite rails/model<CR>
nmap <Leader>v :<C-u>Unite rails/view<CR>

"""""""""""""""""""""""""""
" JavaScriptの設定
"""""""""""""""""""""""""""
" この設定入れるとshiftwidthを1にしてインデントしてくれる
let g:SimpleJsIndenter_BriefMode = 1
" この設定入れるとswitchのインデントがいくらかマシに
let g:SimpleJsIndenter_CaseIndentLevel = -1
" DOMとMozilla関連とES6のメソッドを補完
let g:jscomplete_use = ['dom', 'moz', 'es6th']

"""""""""""""""""""""""""""
" syntasticの設定
"""""""""""""""""""""""""""
" コードの静的解析を行うための設定
let g:syntastic_mode_map = {
      \ "mode" : "passive",
      \ "active_filetypes" : ["ruby", "javascript"],
\}

let g:syntastic_ruby_checkers = ['rubocop']
nnoremap <Leader>s :SyntasticCheck<CR>

"""""""""""""""""""""""""""
" vim-easy-alignの設定
"""""""""""""""""""""""""""
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"""""""""""""""""""""""""""
" Ruby用の設定
"""""""""""""""""""""""""""
" vim-rubyの設定
" private、protectedメソッドなどのネストを1段階深くする
let g:ruby_indent_access_modifier_style="indent"
" . が行頭の時のインデント位置を修正
let g:ruby_indent_block_style = 'do'

" matchitの設定
augroup matchit
  au!
  au FileType ruby let b:match_words = '\<\(module\|class\|def\|begin\|do\|if\|unless\|case\)\>:\<\(elsif\|when\|rescue\)\>:\<\(else\|ensure\)\>:\<end\>'
augroup END

" Rubyのファイルを開いている場合、F4で実行する
au FileType ruby map <F4>  :!ruby %<CR>

"""""""""""""""""""""""""""
" html5.vimの設定
"""""""""""""""""""""""""""
let g:html5_event_handler_attributes_complete = 1
let g:html5_rdfa_attributes_complete = 1
let g:html5_microdata_attributes_complete = 1
let g:html5_aria_attributes_complete = 1

"""""""""""""""""""""""""""
" scss-syntax.vimの設定
"""""""""""""""""""""""""""
" ファイル保存時に自動コンパイル（1で自動実行）
let g:sass_compile_auto = 0
" 編集したファイルから遡るフォルダの最大数
let g:sass_compile_cdloop = 5
" cssファイルが入っているディレクトリ名（前のディレクトリほど優先）
let g:sass_compile_cssdir = ['css', 'stylesheet']
" 自動コンパイルを実行する拡張子
"let g:sass_compile_file = ['scss', 'sass']
let g:sass_started_dirs = []

" erbの静的解析で表示したくないWarning
let g:syntastic_eruby_ruby_quiet_messages =
    \ {'regex': ['possibly useless use of a variable in void context','possibly useless use of + in void context']}

" ERBに関する設定
autocmd FileType eruby exec 'set filetype=' . 'eruby.' . b:eruby_subtype

" 挿入モードから抜ける時に、自動的にpasteモードをOFFにする
autocmd InsertLeave * set nopaste

" ------------------------------------
" lightline.vimの設定
" ------------------------------------
" lightlineのカラースキームを指定
let g:lightline = {
      \ 'colorscheme': 'wombat'
      \ }

" ------------------------------------
" vim-tags.vimの設定
" ------------------------------------
" ファイル保存時に自動タグ生成(:TagsGenerate! で手動生成)
let g:vim_tags_auto_generate = 1

" --------------------------------
" vim-markdown の設定
" --------------------------------
" markdownモードの際、linkの表示が簡潔になる機能を無効
let g:vim_markdown_conceal = 0
" markdownモードのリスト表記のインデントを設定
let g:vim_markdown_new_list_item_indent = 2
" markdownの折りたたみなし
let g:vim_markdown_folding_disabled=1

" 選択した文字列を p でリンク表記に変更(URLはクリップボードにYankしておく)
" 参考情報: https://zenn.dev/skanehira/articles/2021-11-29-vim-paste-clipboard-link
let s:clipboard_register = has('linux') || has('unix') ? '+' : '*'
function! InsertMarkdownLink() abort
  " use register `9`
  let old = getreg('9')
  let link = trim(getreg(s:clipboard_register))
  if link !~# '^http.*'
    normal! gvp
    return
  endif

  " replace `[text](link)` to selected text
  normal! gv"9y
  let word = getreg(9)
  let newtext = printf('[%s](%s)', word, link)
  call setreg(9, newtext)
  normal! gv"9p

  " restore old data
  call setreg(9, old)
endfunction

augroup markdown-insert-link
  au!
  au FileType markdown vnoremap <buffer> <silent> p :<C-u>call InsertMarkdownLink()<CR>
augroup END

" ------------------------------------
" jpo/vim-railscasts-theme の設定
" ------------------------------------
color railscasts
