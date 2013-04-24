package Mailfull::Database;

use strict;
use warnings;
use diagnostics;

use Mailfull::Database::Passwds;
use Mailfull::Database::Forwards;
use Mailfull::Database::Localtable;
use Mailfull::Database::Maildirs;
use Mailfull::Database::Destinations;
use Mailfull::Database::Domains;


##############################
# commit
##############################
sub commit {
    my $self = shift;

    $self->generate_etcs;
    $self->createdb;
}


##############################
# compile
##############################
sub createdb {
    my $self = shift;

    # sync
    system("sync");

    # compile
    system("$Mailfull::Core::Cfg->{bin_postalias}", "$Mailfull::Core::Cfg->{path_forwards}");
    system("$Mailfull::Core::Cfg->{bin_postmap}",   "$Mailfull::Core::Cfg->{path_localtable}");
    system("$Mailfull::Core::Cfg->{bin_postmap}",   "$Mailfull::Core::Cfg->{path_maildirs}");
    system("$Mailfull::Core::Cfg->{bin_postmap}",   "$Mailfull::Core::Cfg->{path_destinations}");
    system("$Mailfull::Core::Cfg->{bin_postmap}",   "$Mailfull::Core::Cfg->{path_domains}");
}


##############################
# generate databases
##############################
sub generate_etcs {
    my $self = shift;

    Mailfull::Database::Passwds->generate;
    Mailfull::Database::Forwards->generate;
    Mailfull::Database::Localtable->generate;
    Mailfull::Database::Maildirs->generate;
    Mailfull::Database::Destinations->generate;
    Mailfull::Database::Domains->generate;
}


1;

