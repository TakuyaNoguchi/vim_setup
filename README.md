# vim_setup

## 使い方

### vim-plugのインストール

```bash
$ curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

インストール後、vimを起動し `:PlugInstall` を実行する。

### リポジトリを任意のディレクトリにcloneし、`setup.sh`を実行

* スクリプト実行後、各設定ファイル、ディレクトリのシンボリックリンクが作成される
* ただしリポジトリ登録されているファイル、ディレクトリが存在する場合、**上書きしない**
