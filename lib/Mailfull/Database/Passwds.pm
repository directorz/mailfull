package Mailfull::Database::Passwds;

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
        # read
        my @lines_d = @{Mailfull::Utils::File->file2array("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_passwds}")};

        foreach my $line (@lines_d) {
            my ($user, $pass) = split(/:/, $line, 2);
            push @lines, $user . "@" . $domain . ":" . $pass;
        }
    }

    # write
    Mailfull::Utils::File->array2file("$Mailfull::Core::Cfg->{path_passwds}", \@lines);
}


1;

