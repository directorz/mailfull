# Mailfull の使い方

  * 下記のコマンドは `/home/mailfull/bin` にて実行しているものとします。
  * ユーザは `root` または `mailfull` にて実行してください。
  * すべてのコマンドは、`-h` オプションで簡単な使用方法を出力して終了します。
  * すべてのコマンドは、`-v` オプションでバージョンを出力して終了します。


## ドメイン

### ドメインの追加

    $ ./vdomainadd example.com
    Enter password for postmaster@example.com:
    Retype:
    $ ./commit

  `example.com` が追加され、`postmaster@example.com` が追加されます。
  パスワードは引数で与えることもできます。

### ドメインの削除

    $ ./vdomaindel example.com

  `./commit` は必要ありません。
  ドメインディレクトリは同階層にバックアップされます。

### ドメインのリストアップ

    $ ./vdomainlist

  設定されているドメインがリストアップされます。


## ユーザ

### ユーザの追加

    $ ./vuseradd user@example.com
    Enter password for user@example.com:
    Retype:
    $ ./commit

  `user@example.com` が追加されます。
  パスワードは引数で与えることもできます。

  SMTP-AUTH, POP/IMAP のユーザ名は、`user@example.com` となります。

### ユーザの削除

    $ ./vuserdel user@example.com

  `postmaster` は削除できません。
  `./commit` は必要ありません。
  ドメインディレクトリは同階層にバックアップされます。

### パスワードの変更

    $ ./vuserpasswd user@example.com
    Enter password for user@example.com:
    Retype:
    $ ./commit

  パスワードは引数で与えることもできます。

### ユーザのリストアップ

    $ ./vuserlist example.com

  引数のドメインに設定されているユーザがリストアップされます。

### パスワードのチェック

    $ ./vusercheckpw user@example.com
    Enter password for user@example.com:
    password is correct.
    $ echo $?
    0

    $ ./vusercheckpw user@example.com
    Enter password for user@example.com:
    password or username is incorrect.
    $ echo $?
    1

  パスワードは引数で与えることもできます。
  パスワードの正誤に応じたメッセージが表示されます。
  コマンドの戻り値として、正しい場合 0、違う場合 1 が戻ります。


## エイリアス

### エイリアスの設定

    $ ./valiasset -a aliasname@example.com dest@example.org[,...]
    $ ./commit

  エイリアスが既に存在する場合は、
  配送先を追加する形で設定されます。
  無ければ追加されます。

    $ ./valiasset -r aliasname@example.com dest@example.org[,...]
    $ ./commit

  エイリアスが既に存在する場合は、
  配送先を置き換える形で設定されます。
  無ければ追加されます。

### エイリアスの解除

    $ ./valiasdel -d aliasname@example.com dest@example.org[,...]
    $ ./commit

  エイリアスの配送先から、
  `dest@example.org[,...]` を取り除く形で設定されます。
  配送先が無くなった場合、エイリアス自体が削除されます。

    $ ./valiasdel -a aliasname@example.com
    $ ./commit

  エイリアス自体を削除します。

### エイリアスのリストアップ

    $ ./valiaslist example.com

  ドメインに設定されているエイリアスのリストが出力されます。

    $ ./valiaslist aliasname@example.com

  エイリアスと、エイリアスに設定されている配送先が出力されます。


## キャッチオール

### キャッチオールの設定

    $ ./vcatchallset example.com user
    $ ./commit

  `example.com` の全てのユーザ宛のメールを、
  ユーザが存在しなければ、`user@example.com` が
  受け取るようになります。

### キャッチオールの解除

    $ ./vcatchalldel example.com
    $ ./commit

  `example.com` に設定されているキャッチオールを解除します。

### キャッチオールの取得

    $ ./vcatchallget example.com

  `example.com` にキャッチオールが設定されていれば、出力します。


## エイリアスドメイン

### エイリアスドメインの追加

    $ ./valiasdomainadd alias.example.com example.com
    $ ./commit

  `example.com` 宛のメールが、`alias.example.com` でも
  受け取れるようになります。

### エイリアスドメインの解除

    $ ./valiasdomaindel alias.example.com
    $ ./commit

  エイリアスドメインを解除します。

### エイリアスドメインのリストアップ

    $ ./valiasdomainlist example.com

  `example.com` に設定されているエイリアスドメインをリストアップします。


## その他

### commit

    $ ./commit

  `/home/mailfull/domains` 以下から設定を生成し、
  `/home/mailfull/etc` 以下の設定ファイルにまとめ、
  各種データベースを作成します。

    $ ./commit -g

  `/home/mailfull/domains` 以下から設定を生成する工程が行われません。
  `/home/mailfull/etc` 以下の設定ファイルから、
  各種データベースを作成する工程のみが実行されます。

### setup

    $ ./setup

  インストール時に使用されます。

