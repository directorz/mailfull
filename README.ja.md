Mailfull - A configuration tool for virtual domain email
==========================================================

要件
----

  * Postfix >= 2.3
  * Dovecot 1.x.x or 2.x.x
  * Perl 5.x.x
    * Digest::SHA1 module

クイックスタートガイド
----------------------

  リポジトリ取得とユーザの作成

    # cd /home
    # git clone git://github.com/directorz/mailfull.git
    # useradd -M -s /bin/bash mailfull

  初期ファイルの作成

    # cd /home/mailfull/bin
    # ./setup

  生成されたコンフィグをコピー

    # cd /home/mailfull/etc
    # cp main.cf.sample /etc/postfix/main.cf
    # cp dovecot.conf.sample.2 /etc/dovecot/dovecot.conf

  Postfix と Dovecot を起動

    # /etc/init.d/dovecot start
    # /etc/init.d/postfix start

  完了

詳細
----

  Read docs/*

機能
----

  * vpopmail ライクな操作
  * ドメインやユーザの追加が、postfix, dovecot の再起動無しで可能
  * バーチャルユーザとリアルユーザを同居して利用可能
  * Mailfull は実際の配送には関与せず設定ファイルを生成するのみ
  * ユーザ毎に、メールをそれぞれのプログラムに渡すことが可能

実装予定
--------

  * 簡易 ML 機能

