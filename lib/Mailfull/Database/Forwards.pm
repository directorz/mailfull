package Mailfull::Database::Forwards;

use strict;
use warnings;
use diagnostics;

use Mailfull::Utils::File;


sub generate {
    my $self = shift;

    $self->_summarize_forwards;

    # domain list
    my @domains = Mailfull::Utils::File->ls("$Mailfull::Core::Cfg->{dir_data}", "d");

    # generate lines
    my @lines = ();
    foreach my $domain (@domains) {
        # read
        my @lines_df = @{Mailfull::Utils::File->file2array("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_forwards}")};

        foreach my $line (@lines_df) {
            my ($key, $value) = split(/:/, $line, 2);

            my $domain_underscored = $domain;
            $domain_underscored =~ s/-/_/g;

            if ( $value =~ /^\s*$/ ) {
                push @lines, $domain_underscored . "|" . $key . ":" . "/dev/null";
            } else {
                push @lines, $domain_underscored . "|" . $key . ":" . $value;
            }
        }
    }

    # drop realuser
    push @lines, "$Mailfull::Core::Cfg->{username}:/dev/null";

    # write
    Mailfull::Utils::File->array2file("$Mailfull::Core::Cfg->{path_forwards}", \@lines);
}


sub _summarize_forwards {
    my $self = shift;

    # domain list
    my @domains = Mailfull::Utils::File->ls("$Mailfull::Core::Cfg->{dir_data}", "d");

    # user's forward -> domain's forward
    foreach my $domain (@domains) {
        # user list
        my @users = Mailfull::Utils::File->ls("$Mailfull::Core::Cfg->{dir_data}/$domain", "d");

        # generate lines
        my @lines = ();
        foreach my $user (@users) {
            unless ( -f "$Mailfull::Core::Cfg->{dir_data}/$domain/$user/$Mailfull::Core::Cfg->{name_userforward}" ) {
                push @lines, $user . ":";
                next;
            }

            # read
            my @lines_uf = @{Mailfull::Utils::File->file2array("$Mailfull::Core::Cfg->{dir_data}/$domain/$user/$Mailfull::Core::Cfg->{name_userforward}")};

            # remove comment
            @lines_uf = grep { ! /^\s*\#.*/ } @lines_uf;

            # remove empty line
            @lines_uf = grep { ! /^\s*$/ } @lines_uf;

            push @lines, $user . ":" . join(",", @lines_uf);
        }

        # write
        Mailfull::Utils::File->array2file("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_forwards}", \@lines);
    }
}


1;

