" vim内部で使われる文字エンコーディングをutf-8に設定する
set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8 " 保存時の文字コード
" 読み込み時の文字コードの自動判別. 左側が優先される
set fileencodings=ucs-boms,utf-8,euc-jp,cp932
set fileformats=unix,dos,mac " 改行コードの自動判別. 左側が優先される
set history=1000
set wildmenu " コマンドモードの補完
set history=5000 " 保存するコマンド履歴の数
set whichwrap=b,s,h,l,<,>,[,] " カーソルを行頭、行末で止まらないようにする"
" 他のアプリとクリップボードを共有
set clipboard=unnamed,autoselect
" swapファイルを生成しない
set noswapfile
" カーソル前の文字削除
inoremap <silent> <C-h> <C-g>u<C-h>
" カーソル後の文字削除
inoremap <silent> <C-d> <Del>
" バックアップファイルを作成しない
set nobackup
" 括弧のハイライトを消す
let loaded_matchparen = 1
" ハイライトを有効化する
syntax enable
" 挿入モードでTABを挿入するとき、代わりに適切な数の空白を使う
set expandtab
" 新しい行を開始したとき、新しい行のインデントを現在行と同じにする
set autoindent
" ステータスラインの表示のために必要
set laststatus=2
set t_Co=256
" カーソル位置を記憶する
au BufWritePost * if &filetype != "gitcommit" | mkview | endif
autocmd BufReadPost * if &filetype != "gitcommit" | loadview | endif

" 編集中のファイルパスをクリップボードにコピーする
function! g:CopyFilePath()
  let @* = expand("%:p")
  echo @*
endfunction

" 編集中のファイル名をクリップボードにコピーする
function! g:CopyFileName()
  let @* = expand("%:t")
  echo @*
endfunction

" 編集中のファイルの存在するフォルダのパスをクリップボードにコピーする
function! g:CopyFolderPath()
  let @* = expand("%:p:h")
  echo @*
endfunction

" コマンドとして実行できるようにする
command! CopyFilePath :call g:CopyFilePath()
command! CopyFileName :call g:CopyFileName()
command! CopyFolderPath :call g:CopyFolderPath()

" 1つ前に実行したコマンドを実行する
nnoremap c. q:k<CR>

" バッファの移動を楽にする
nnoremap <silent> gp :bprevious<CR>
nnoremap <silent> gn :bnext<CR>

" IMEをノーマルモードに切り替わる時にOFFにする
if executable('fcitx-remote')
  function! ImInActivate()
    call system('fcitx-remote -c')
  endfunction
  " Insert-modeのスクロールでABCDが入力されてしまう点に注意。
  " set nocompatible を設定しても矢印キーの入力時にABCDが入力されてしまうため
  inoremap <silent> <C-[> <ESC>:call ImInActivate()<CR>
endif

" Ruby, JSのファイルを編集する際は行末の空白を削除する
autocmd BufWritePost *.rb call DeleteLastSpace()
autocmd BufWritePost *.js call DeleteLastSpace()
function! DeleteLastSpace()
    let save_cursor = getpos('.')
    silent exec 'retab'
    silent exec '%s/ \+$//e'
    call setpos(".", save_cursor)
endfunction

" 参考サイト(http://postd.cc/how-to-boost-your-vim-productivity/)
" Leaderの設定(デフォルトは\)
let mapleader = "\<Space>"
" Space + w でファイルの保存
nnoremap <Leader>w :w<CR>
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
" NeoBundle
" -------------------------------
if has('vim_starting')
  if &compatible
    set nocompatible
  endif

  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle'))

NeoBundleFetch 'Shougo/neobundle.vim', {'type__protocol' : 'ssh' }
  " Visual Mode の改良プラグイン
  NeoBundle 'terryma/vim-expand-region', { 'type__protocol' : 'ssh' }

  " コード補完
  NeoBundle 'Shougo/neocomplete.vim', {'type__protocol' : 'ssh' }
  NeoBundle 'Konfekt/FastFold', {'type__protocol' : 'ssh' }

  " ドキュメント参照
  NeoBundle 'thinca/vim-ref', {'type__protocol' : 'ssh' }
  NeoBundle 'yuku-t/vim-ref-ri', {'type__protocol' : 'ssh' }

  " タグジャンプ
  NeoBundle 'szw/vim-tags', {'type__protocol' : 'ssh'}

  NeoBundle 'vim-ruby/vim-ruby', {'type__protocol' : 'ssh' }

  " Rubyのブロックを対象にするテキストオブジェクト(r)を追加する
  " dir でブロックを削除、yir でブロックをヤンクなど
  NeoBundle 'kana/vim-textobj-user', {'type__protocol': 'ssh'}
  NeoBundle 'rhysd/vim-textobj-ruby', {'type__protocol' : 'ssh'}

  " endの自動補完
  NeoBundle 'tpope/vim-endwise', {'type__protocol' : 'ssh' }

  " カーソル移動を楽にする(ace-jump-mode のようなもの)
  NeoBundle 'Lokaltog/vim-easymotion', {'type__protocol' : 'ssh' }

  " % で対応する括弧に移動する機能を拡張
  NeoBundle 'tmhedberg/matchit', {'type__protocol' : 'ssh' }

  " ファイルオープンを便利に
  NeoBundle 'Shougo/unite.vim'

  " Unite.vimで最近使ったファイルを表示できるようにする
  NeoBundle 'Shougo/neomru.vim', {'type__protocol' : 'ssh' }

  " Rails向けのコマンドを提供する
  NeoBundle 'tpope/vim-rails', {'type__protocol' : 'ssh' }

  " あらかじめ登録しておいた対応表に沿って変換を行う
  NeoBundle 'AndrewRadev/switch.vim', { 'type__protocol' : 'ssh' }

  " コメントに関するプラグイン。prefixキーは C-_
  NeoBundle 'tomtom/tcomment_vim', {'type__protocol' : 'ssh' }

  " シングルクオートとダブルクオートの入れ替え等
  NeoBundle 'tpope/vim-surround', {'type__protocol' : 'ssh' }

  " ログファイルを色づけしてくれる
  NeoBundle 'vim-scripts/AnsiEsc.vim', {'type__protocol' : 'ssh' }

  " 行末の半角スペースを可視化
  NeoBundle 'bronson/vim-trailing-whitespace', {'type__protocol' : 'ssh' }

  " vimでスニペットを利用するための設定
  NeoBundle 'Shougo/neosnippet', {'type__protocol' : 'ssh' }
  NeoBundle 'Shougo/neosnippet-snippets', {'type__protocol' : 'ssh' }

  " vimでemmetを使用する
  NeoBundle 'mattn/emmet-vim', {'type__protocol' : 'ssh' }

  " Railsのファイル移動を楽にする
  NeoBundle 'basyura/unite-rails', {'type__protocol' : 'ssh' }

  " Markdown
  NeoBundle 'plasticboy/vim-markdown', {'type__protocol' : 'ssh'}
  NeoBundle 'kannokanno/previm', {'type__protocol' : 'ssh' }
  NeoBundle 'tyru/open-browser.vim', {'type__protocol' : 'ssh' }

  " 括弧の入力を楽にする
  NeoBundle 'kana/vim-smartinput', { 'type__protocol' : 'ssh' }

  " JavaScript
  NeoBundle 'pangloss/vim-javascript', { 'type__protocol' : 'ssh' }

  " JavaScriptのインデント
  NeoBundle 'jiangmiao/simple-javascript-indenter', { 'type__protocol' : 'ssh' }

  " JavaScriptの色付け
  NeoBundle 'jelera/vim-javascript-syntax', { 'type__protocol' : 'ssh' }

  " VimでPerl、Rubyの正規表現を使用する(置換は %S を使用することで利用可能)
  NeoBundle 'othree/eregex.vim', { 'type__protocol' : 'ssh' }

  " 整形を楽に行うためのプラグイン
  NeoBundle 'junegunn/vim-easy-align', { 'type__protocol' : 'ssh' }

  " htmlに関するプラグイン
  NeoBundle 'othree/html5.vim', { 'type__protocol' : 'ssh' }

  " Sassに関するプラグイン
  NeoBundle 'cakebaker/scss-syntax.vim', { 'type__protocol' : 'ssh' }

  " YAMLに関するプラグイン
  NeoBundle 'mrk21/yaml-vim', { 'type__protocol' : 'ssh' }

  " コードの静的解析ツール
  NeoBundle 'scrooloose/syntastic', { 'type__protocol' : 'ssh' }

  " ステータスラインの表示を変更
  NeoBundle 'itchyny/lightline.vim', { 'type__protocol' : 'ssh' }

  " ディレクトリのツリー表示
  NeoBundle 'scrooloose/nerdtree', { 'type__protocol' : 'ssh' }
call neobundle#end()

NeoBundleCheck

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

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

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

" --------------------------------
" vim-markdown の設定
" --------------------------------
" markdownモードの時に neocomplete foldmethod=expr が出る場合の対処
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

" markdownモードの際、linkの表示が簡潔になる機能を無効
let g:vim_markdown_conceal = 0
" markdownモードのリスト表記のインデントを設定
let g:vim_markdown_new_list_item_indent = 2

" --------------------------------
" vim-easymotion の設定
" --------------------------------
" ホームポジションに近いキーを使う
let g:EasyMotion_keys='hjklasdfgyuiopqwertnmzxcvbHJKLASDFGYUIOPQWERTNMZXCVB'
" 「;」 + 何かにマッピング
let g:EasyMotion_leader_key=";"
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

nmap s <Plug>(easymotion-s2)
vmap s <Plug>(easymotion-s2)
" surround.vimとかぶるので`z`" jで現在行以降、kで現在行以前を対象に検索する
omap z <Plug>(easymotion-s2)
" j で現在行以降、k で現在行以前を対象に検索
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

""""""""""""""""""""""""""""""
" Unit.vimの設定
""""""""""""""""""""""""""""""
" http://blog.remora.cx/2010/12/vim-ref-with-unite.html
" 入力モードで開始する
let g:unite_enable_start_insert=1
" 大文字小文字を区別しない
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1
" バッファ一覧
noremap <C-w> :Unite buffer<CR>
" sourcesを「今開いているファイルのディレクトリ」とする
noremap <C-@> :<C-u>UniteWithBufferDir file -buffer-name=file<CR>
" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>

"------------------------------------
" neosnippet
"------------------------------------
let s:default_snippet = '~/.vim/bundle/neosnippet-snippets/neosnippets/'
let s:my_snippet = '~/.vim/my_snippets/' " 自分で定義するSnippet
let g:neosnippet#snippets_directory = s:my_snippet

let g:neosnippet#snippets_directory = s:default_snippet . ',' . s:my_snippet

" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" RailsのSnippetの設定
autocmd User Rails.view*                 NeoSnippetSource ~/.vim/my_snippets/ruby_snip/ruby.rails.view.snip
autocmd User Rails.controller*           NeoSnippetSource ~/.vim/my_snippets/ruby_snip/ruby.rails.controller.snip
autocmd User Rails/db/migrate/*          NeoSnippetSource ~/.vim/my_snippets/ruby_snip/ruby.rails.migrate.snip
autocmd User Rails/config/routes.rb      NeoSnippetSource ~/.vim/my_snippets/ruby_snip/ruby.rails.route.snip

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

" 最近開いたファイルを開く
nnoremap <leader>r :<C-u>Unite file_mru<CR>

"""""""""""""""""""""""""""
"JavaScriptの設定
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
" コードの静的解析を行うための設定(JavaScriptの設定)
let g:syntastic_mode_map = {
      \ "mode" : "active",
      \ "active_filetypes" : ["javascript", "json"],
\}

"""""""""""""""""""""""""""
" vim-easy-alignの設定
"""""""""""""""""""""""""""
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Ruby用のmatchitの設定
augroup matchit
  au!
  au FileType ruby let b:match_words = '\<\(module\|class\|def\|begin\|do\|if\|unless\|case\)\>:\<\(elsif\|when\|rescue\)\>:\<\(else\|ensure\)\>:\<end\>'
augroup END

" Rubyのファイルを開いている場合、F4で実行する
au FileType ruby map <F4>  :!ruby %<CR>

"""""""""""""""""""""""""""
" tcomment_vimの設定
"""""""""""""""""""""""""""
" tcommentで使用する形式を追加
if !exists('g:tcomment_types')
  let g:tcomment_types = {}
endif
let g:tcomment_types = {
      \'php_surround' : "<?php %s ?>",
      \'eruby_surround' : "<%% %s %%>",
      \'eruby_surround_minus' : "<%% %s -%%>",
      \'eruby_surround_equality' : "<%%= %s %%>",
\}

" マッピングを追加
function! SetErubyMapping2()
  nmap <buffer> <C-_>c :TCommentAs eruby_surround<CR>
  nmap <buffer> <C-_>- :TCommentAs eruby_surround_minus<CR>
  nmap <buffer> <C-_>= :TCommentAs eruby_surround_equality<CR>

  vmap <buffer> <C-_>c :TCommentAs eruby_surround<CR>
  vmap <buffer> <C-_>- :TCommentAs eruby_surround_minus<CR>
  vmap <buffer> <C-_>= :TCommentAs eruby_surround_equality<CR>
endfunction

" erubyのときだけ設定を追加
au FileType eruby call SetErubyMapping2()

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
    \ {'regex': 'possibly useless use of a variable in void context'}

" ERBに関する設定
autocmd FileType eruby exec 'set filetype=' . 'eruby.' . b:eruby_subtype

" 挿入モードから抜ける時に、自動的にpasteモードをOFFにする
autocmd InsertLeave * set nopaste

" Switch.vimの設定
function! s:separate_defenition_to_each_filetypes(ft_dictionary)
  let result = {}

  for [filetypes, value] in items(a:ft_dictionary)
    for ft in split(filetypes, ",")
      if !has_key(result, ft)
        let result[ft] = []
      endif

      call extend(result[ft], copy(value))
    endfor
  endfor

  return result
endfunction

" ------------------------------------
" switch.vimの設定
" ------------------------------------
nnoremap ! :Switch<CR>
let s:switch_definition = {
      \ '*': [
      \   ['is', 'are']
      \ ],
      \ 'ruby,eruby,haml' : [
      \   ['if', 'unless'],
      \   ['while', 'until'],
      \   ['.blank?', '.present?'],
      \   ['include', 'extend'],
      \   ['class', 'module'],
      \   ['.inject', '.delete_if'],
      \   ['.map', '.map!'],
      \   ['attr_accessor', 'attr_reader', 'attr_writer'],
      \ ],
      \ 'markdown' : [
      \   ['[ ]', '[x]']
      \ ]
      \ }

let s:switch_definition = s:separate_defenition_to_each_filetypes(s:switch_definition)
function! s:define_switch_mappings()
  if exists('b:switch_custom_definitions')
    unlet b:switch_custom_definitions
  endif

  let dictionary = []
  for filetype in split(&ft, '\.')
    if has_key(s:switch_definition, filetype)
      let dictionary = extend(dictionary, s:switch_definition[filetype])
    endif
  endfor

  if has_key(s:switch_definition, '*')
    let dictionary = extend(dictionary, s:switch_definition['*'])
  endif
endfunction

augroup SwitchSetting
  autocmd!
  autocmd Filetype * if !empty(split(&ft, '\.')) | call <SID>define_switch_mappings() | endif
augroup END

" ------------------------------------
" lightline.vimの設定
" ------------------------------------
" lightlineのカラースキームを指定
let g:lightline = {
      \ 'colorscheme': 'wombat'
      \ }

" ------------------------------------
" NERDTreeの設定
" ------------------------------------
nnoremap <silent><C-i> :NERDTreeToggle<CR>

" ファイル形式の検出の有効化する
" ファイル形式別プラグインのロードを有効化する
" ファイル形式別インデントのロードを有効化する
filetype plugin indent on
