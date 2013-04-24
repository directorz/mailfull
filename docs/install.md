# Mailfull Installation Guide

### Store Files

    # mkdir /home/mailfull

    # tar zxvf mailfull-x.x.x.tar.gz
    # cd mailfull-x.x.x
    # cp -a bin lib /home/mailfull

### Add group and user

    # groupadd mailfull
    # useradd -M -s /bin/bash -g mailfull mailfull

### Configuration (Optional)

  If you wanted to change default configuration,
  store `./myconfig.pl` to `/home/mailfull/lib/Mailfull/Common/myconfig.pl`,
  edit it.

### Create initial files and sample configuration

    # cd /home/mailfull/bin
    # ./setup

  `/home/mailfull/domains`, `/home/mailfull/etc` and
  several files will be created.

### Configure Postfix and Dovecot

    # cd /home/mailfull/etc/main.cf.sample /etc/postfix/main.cf

  If necessary, edit `master.cf` to enable SMTP-AUTH.

    # cp -a dovecot.conf.sample.2 /etc/dovecot/dovecot.conf
       <or>
    # cp -a dovecot.conf.sample.1 /etc/dovecot.conf

### Start Postfix and Dovecot

    # /etc/init.d/dovecot start
    # /etc/init.d/postfix start

### Done !

