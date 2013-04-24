Mailfull - A configuration tool for virtual domain email
========================================================

Requirements
------------

  * Postfix 2.x.x
  * Dovecot 1.x.x or 2.x.x
  * Perl 5.x.x
    * Digest::SHA1 module

Quick Start
-----------

  Get repository and creat user.

    # cd /home
    # git clone git://github.com/directorz/mailfull.git
    # useradd -M -s /bin/bash mailfull

  Create initial files.

    # cd /home/mailfull/bin
    # ./setup

  Copy generated configuration files.

    # cd /home/mailfull/etc
    # cp main.cf.sample /etc/postfix/main.cf
    # cp dovecot.conf.sample.2 /etc/dovecot/dovecot.conf

  Start Postfix and Dovecot.

    # /etc/init.d/dovecot start
    # /etc/init.d/postfix start

  Have Fun ! :)

More info
---------

  Read docs/*

Features
--------

  * The operation is similar to vpopmail.
  * Do not need to restart postfix and dovecot to reflect the settings.
  * Virtual user and system user can be used concurrently.
  * Mailfull is only to generate configuration files,
    is not used in delivery processes.
  * Mails can be passed to the program.

Future work
-----------

  * Simple mailing list support

