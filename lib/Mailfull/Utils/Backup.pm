package Mailfull::Utils::Backup;

use strict;
use warnings;
use diagnostics;


##############################
# backup directory of domain
##############################
sub backup_domain {
    my $self = shift;
    my ($domain) = @_;

    my $basedir = "$Mailfull::Core::Cfg->{dir_data}";
    my $suffix = $self->_make_timestr;

    rename("$basedir/$domain", "$basedir/.$domain.$suffix") or die "$!";
}


##############################
# backup directory of user
##############################
sub backup_user {
    my $self = shift;
    my ($username, $domain) = @_;

    my $basedir = "$Mailfull::Core::Cfg->{dir_data}/$domain";
    my $suffix = $self->_make_timestr;

    rename("$basedir/$username", "$basedir/.$username.$suffix") or die "$!";
}


##############################
# make timestamp
##############################
sub _make_timestr {
    my $self = shift;

    my ($sec, $min, $hour, $mday, $mon, $year) = localtime(time);
    my $date = ($year + 1900) * 10000 + ($mon + 1) * 100 + $mday;
    my $time = $hour * 10000 + $min * 100 + $sec;
    my $str_time = $date * 1000000 + $time;

    return "$str_time";
}


1;

