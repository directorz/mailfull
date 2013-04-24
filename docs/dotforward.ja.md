# .forward の使い方

  ユーザは `.forward` を使用して、メールを転送したりプログラムを起動したりすることができます。
  `.forward` を編集した場合も、反映には `commit` が必要です。


## 設定例

### 自分のディレクトリに残し、転送し、プログラムに渡す

    $ cat /home/mailfull/domains/example.com/user/.forward
    /home/mailfull/domains/example.com/user/Maildir/
    dest@example.org
    "| /path/to/mail.pl"


### procmail を利用する

  起動されたプログラムの環境変数 `$HOME` は、`/home/mailfull` が設定されてしまうので、
  以下のように変更する必要があります。

    $ cat /home/mailfull/domains/example.com/user/.forward
    "|IFS=' ' && exec /usr/bin/procmail -f- /home/mailfull/domains/example.com/user/.procmailrc || exit 75 #/home/mailfull/domains/example.com/user/Maildir/"


    $ cat /home/mailfull/domains/example.com/user/.procmailrc
    HOME=/home/mailfull/domains/example.com/user
    SHELL=/bin/bash
    PATH=/usr/local/bin:/bin:/usr/bin
    MAILDIR=${HOME}/Maildir
    DEFAULT=${MAILDIR}/
    #LOGFILE=${MAILDIR}/.procmail.log

    ## recipe
    #:0 H
    #...

