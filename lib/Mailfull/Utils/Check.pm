package Mailfull::Utils::Check;

use strict;
use warnings;
use diagnostics;

use Mailfull::Utils::File;


##############################
# domain
##############################
sub domain_exist {
    my $self = shift;
    my ($domain) = @_;

    if ( -d "$Mailfull::Core::Cfg->{dir_data}/$domain" ) {
        return 1;
    } else {
        return;
    }
}


sub domain_correct_format {
    my $self = shift;
    my ($domain) = @_;

    if ( $domain !~ /@/ && $domain !~ /\s/ && $domain =~ /.+\..+/ ) {
        return 1;
    } else {
        return;
    }
}


sub domain_is_aliasdomaintarget {
    my $self = shift;
    my ($domain) = @_;

    # read
    my %hash = %{Mailfull::Utils::File->file2hash("$Mailfull::Core::Cfg->{path_aliasdomains}", ':')};

    foreach my $value ( values %hash ) {
        if ($value eq $domain ) {
            return 1;
        }
    }

    return;
}


##############################
# user
##############################
sub username_exist {
    my $self = shift;
    my ($domain, $username) = @_;

    if ( -d "$Mailfull::Core::Cfg->{dir_data}/$domain/$username" ) {
        return 1;
    } else {
        return;
    }
}


sub username_correct_format {
    my $self = shift;
    my ($username) = @_;

    if ( $username !~ /@/ && $username !~ /\s/ ) {
        return 1;
    } else {
        return;
    }
}


sub username_is_catchalltarget {
    my $self = shift;
    my ($domain, $username) = @_;

    # read
    my @lines = @{Mailfull::Utils::File->file2array("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_catchall}")};

    if ( defined($lines[0]) ) {
        if ( $lines[0] eq $username ) {
            return 1;
        }
    } else {
        return;
    }
}


##############################
# catchall
##############################
sub catchall_exist {
    my $self = shift;
    my ($domain) = @_;

    # read
    my @lines = @{Mailfull::Utils::File->file2array("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_catchall}")};

    if ( ! defined($lines[0]) || $lines[0] eq "" ) {
        return;
    } else {
        return 1;
    }
}


##############################
# alias
##############################
sub aliasname_exist {
    my $self = shift;
    my ($domain, $aliasname) = @_;

    # read
    my %hash = %{Mailfull::Utils::File->file2hash("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_aliases}", ':')};

    if ( exists($hash{"$aliasname"}) ) {
        return 1;
    } else {
        return;
    }
}


sub aliasname_correct_format {
    my $self = shift;
    my ($aliasname) = @_;

    return $self->username_correct_format($aliasname);
}


sub aliasdest_exist {
    my $self = shift;
    my ($domain, $aliasname, $dest) = @_;

    # read
    my %hash = %{Mailfull::Utils::File->file2hash("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_aliases}", ':')};

    if ( exists($hash{"$aliasname"}) ) {
        foreach my $d ( split(/,/, $hash{"$aliasname"}) ) {
            return 1 if $d eq $dest;
        }
    } else {
        return;
    }
}


sub aliasdest_correct_format {
    my $self = shift;
    my ($dest) = @_;

    if ( $dest =~ /.+@.+/ && $dest !~ /\s/ ) {
        return 1;
    } else {
        return;
    }
}


##############################
# aliasdomain
##############################
sub aliasdomain_exist {
    my $self = shift;
    my ($aliasdomain) = @_;

    # read
    my %hash = %{Mailfull::Utils::File->file2hash("$Mailfull::Core::Cfg->{path_aliasdomains}", ':')};

    if ( exists($hash{"$aliasdomain"}) ) {
        return 1;
    } else {
        return;
    }
}


sub aliasdomain_correct_format {
    my $self = shift;
    my ($aliasdomain) = @_;

    return $self->domain_correct_format($aliasdomain);
}


1;

