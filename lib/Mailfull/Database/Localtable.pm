package Mailfull::Database::Localtable;

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
        my $escaped_domain = $domain;

        # underscored
        $escaped_domain =~ s/-/_/g;

        # escape
        $escaped_domain =~ s/\./\\\./g;

        push @lines, "/^" . $escaped_domain . "\\|.*\$/" . " local";
    }

    # write
    Mailfull::Utils::File->array2file("$Mailfull::Core::Cfg->{path_localtable}", \@lines);
}


1;

