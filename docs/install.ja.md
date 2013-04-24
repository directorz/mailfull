# Mailfull インストールガイド

### ファイルの配置

    # mkdir /home/mailfull

    # tar zxvf mailfull-x.x.x.tar.gz
    # cd mailfull-x.x.x
    # cp -a bin lib /home/mailfull

### ユーザ・グループの作成

    # groupadd mailfull
    # useradd -M -s /bin/bash -g mailfull mailfull

### 設定 (オプション)

  `./myconfig.pl` を確認し、デフォルトの設定を変更する必要がある場合は、
  `/home/mailfull/lib/Mailfull/Common/myconfig.pl` に配置し、
  適宜編集して下さい。

### 初期ファイルと設定サンプルの生成

    # cd /home/mailfull/bin
    # ./setup

  `/home/mailfull/domains`, `/home/mailfull/etc` と
  その配下にいくつかのファイルが作成されます。

### Postfix と Dovecot の設定

    # cd /home/mailfull/etc/main.cf.sample /etc/postfix/main.cf

  必要があれば、`master.cf` を編集し SMTP-AUTH を有効にして下さい。

    # cp -a dovecot.conf.sample.2 /etc/dovecot/dovecot.conf
       <or>
    # cp -a dovecot.conf.sample.1 /etc/dovecot.conf

### Postfix と Dovecot を起動

    # /etc/init.d/dovecot start
    # /etc/init.d/postfix start

### 完了

