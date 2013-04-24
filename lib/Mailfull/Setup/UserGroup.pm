package Mailfull::Setup::UserGroup;

use strict;
use warnings;
use diagnostics;


##############################
# make user and group
##############################
sub setup {
    my $self = shift;

    my $username = $Mailfull::Core::Cfg->{username};
    my $groupname = $Mailfull::Core::Cfg->{groupname};
    my $uid = getpwnam $Mailfull::Core::Cfg->{username};
    my $gid = getgrnam $Mailfull::Core::Cfg->{groupname};

    # group
    if ( ! defined($uid) || ! defined($gid) ) {
        print << "___EOL___";
user \"$username\" or group \"$groupname\" does not exist.

run the following command and run setup again.
------8<------
groupadd $groupname
useradd -M -s /bin/bash -g $groupname $username
------8<------
___EOL___

        exit 1;
    } else {
        print "user \"$username\" and group \"$groupname\" exist.\n";
    }
}


1;

