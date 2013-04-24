package Mailfull::Setup;

use strict;
use warnings;
use diagnostics;

use Mailfull::Setup::UserGroup;
use Mailfull::Setup::DirsFiles;
use Mailfull::Setup::Postfix;
use Mailfull::Setup::Dovecot;
use Mailfull::Utils::Locker;


##############################
# setup
##############################
sub setup {
    my $self = shift;

    Mailfull::Utils::Locker->my_lock;

    Mailfull::Setup::UserGroup->setup;
    Mailfull::Setup::DirsFiles->setup;
    Mailfull::Setup::Postfix->setup;
    Mailfull::Setup::Dovecot->setup;

    Mailfull::Utils::Locker->my_unlock;
}


1;

