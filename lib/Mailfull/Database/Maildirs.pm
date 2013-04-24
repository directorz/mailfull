package Mailfull::Database::Maildirs;

use strict;
use warnings;
use diagnostics;

use Mailfull::Utils::File;


sub generate {
    my $self = shift;

    # domain list
    my @domains = Mailfull::Utils::File->ls("$Mailfull::Core::Cfg->{dir_data}", "d");

    # generate lines
    my @lines = ();
    foreach my $domain (@domains) {
        # user list
        my @users = Mailfull::Utils::File->ls("$Mailfull::Core::Cfg->{dir_data}/$domain", "d");

        foreach my $user (@users) {
            push @lines, $user . "@" . $domain . " $domain/$user/Maildir/";
        }
    }

    # write
    Mailfull::Utils::File->array2file("$Mailfull::Core::Cfg->{path_maildirs}", \@lines);
}


1;

