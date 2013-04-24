package Mailfull::Database::Domains;

use strict;
use warnings;
use diagnostics;

use Mailfull::Utils::File;


sub generate {
    my $self = shift;

    # domain list
    my @domains = Mailfull::Utils::File->ls("$Mailfull::Core::Cfg->{dir_data}", "d");

    # aliasdomain list
    my %hash = %{Mailfull::Utils::File->file2hash("$Mailfull::Core::Cfg->{path_aliasdomains}", ':')};
    my @aliasdomains = sort keys %hash;

    # generate lines
    my @lines = ();
    foreach my $domain (@domains, @aliasdomains) {
        push @lines, $domain . " virtual";
    }

    # write
    Mailfull::Utils::File->array2file("$Mailfull::Core::Cfg->{path_domains}", \@lines);
}


1;

