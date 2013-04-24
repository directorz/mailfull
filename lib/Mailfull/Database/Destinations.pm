package Mailfull::Database::Destinations;

use strict;
use warnings;
use diagnostics;

use Mailfull::Utils::File;


sub generate {
    my $self = shift;

    # make hash from forwards
    my %hash_forwards = %{Mailfull::Utils::File->file2hash("$Mailfull::Core::Cfg->{path_forwards}", ':')};

    # domain list
    my @domains = Mailfull::Utils::File->ls("$Mailfull::Core::Cfg->{dir_data}", "d");

    # generate lines
    my @lines = ();
    foreach my $domain (@domains) {
        # user list
        my @users = Mailfull::Utils::File->ls("$Mailfull::Core::Cfg->{dir_data}/$domain", "d");

        # get catch all user
        my @lines_ca = @{Mailfull::Utils::File->file2array("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_catchall}")};
        my $catchalluser = defined($lines_ca[0]) ? $lines_ca[0] : "";

        foreach my $user (@users) {
            # make address
            my $address = $user eq $catchalluser ?
                "@" . $domain : $user . "@" . $domain;

            my $domain_underscored = $domain;
            $domain_underscored =~ s/-/_/g;

            if ( $hash_forwards{"$domain_underscored" . "|" . "$user"} eq "/dev/null" ) {
                # if forward is "/dev/null"
                # -> "user@example.com user@example.com"
                push @lines, $address . " " . $user . "@" . $domain;
            } else {
                # if forward is exist
                # -> "user@example.com example.com|user"
                push @lines, $address . " " . $domain_underscored . "|" . $user;
            }
        }

        # get aliases
        my @lines_da = @{Mailfull::Utils::File->file2array("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_aliases}")};

        foreach my $line (@lines_da) {
            my ($aliasname, $dests) = split(/:/, $line, 2);

            # remove space at beginning and eol
            $dests =~ s/^\s*(.*?)\s*$/$1/;

            if ( $dests ne "" ) {
                push @lines, $aliasname . "@" . $domain . " " . $dests;
            }
        }
    }

    # write
    Mailfull::Utils::File->array2file("$Mailfull::Core::Cfg->{path_destinations}", \@lines);

    $self->_generate_aliasdomain;
}


sub _generate_aliasdomain {
    my $self = shift;

    # make file if not exist
    unless ( -f "$Mailfull::Core::Cfg->{path_aliasdomains}" ) {
        Mailfull::Utils::File->touch("$Mailfull::Core::Cfg->{path_aliasdomains}", $Mailfull::Core::Cfg->{umask_data});
        return;
    }

    # make hash from destinations
    my %hash_destinations = %{Mailfull::Utils::File->file2hash("$Mailfull::Core::Cfg->{path_destinations}", ' ')};

    # make hash from aliasdomains
    my %hash_aliasdomains = %{Mailfull::Utils::File->file2hash("$Mailfull::Core::Cfg->{path_aliasdomains}", ':')};

    # generate lines
    my @lines = @{Mailfull::Utils::File->file2array("$Mailfull::Core::Cfg->{path_destinations}")};

    foreach my $aliasdomain ( sort keys %hash_aliasdomains ) {
        my $destdomain = $hash_aliasdomains{"$aliasdomain"};

        foreach my $address (keys %hash_destinations) {
            my ($user, $domain) = split(/@/, $address);

            if ( $domain eq $destdomain ) {
                if ( $user eq "" ) {
                    # if catch all
                    # -> "@alias.example.com user@example.com"
                    push @lines, "@" . $aliasdomain . " " . $hash_destinations{"$address"};
                } else {
                    # -> "user@alias.example.com user@example.com"
                    push @lines, $user . "@" . $aliasdomain . " " . $address;
                }
            }
        }
    }

    # write
    Mailfull::Utils::File->array2file("$Mailfull::Core::Cfg->{path_destinations}", \@lines);
}


1;

