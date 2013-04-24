package Mailfull::Setup::DirsFiles;

use strict;
use warnings;
use diagnostics;

use Mailfull::Utils::File;
use Mailfull::Database;


##############################
# make file and directory
##############################
sub setup {
    my $self = shift;

    $self->_create_dir("$Mailfull::Core::Cfg->{dir_data}", $Mailfull::Core::Cfg->{umask_data});
    $self->_create_file("$Mailfull::Core::Cfg->{path_aliasdomains}", $Mailfull::Core::Cfg->{umask_data});

    $self->_create_dir("$Mailfull::Core::Cfg->{dir_etc}", $Mailfull::Core::Cfg->{umask_etc});
    $self->_create_file("$Mailfull::Core::Cfg->{path_domains}", $Mailfull::Core::Cfg->{umask_etc});
    $self->_create_file("$Mailfull::Core::Cfg->{path_destinations}", $Mailfull::Core::Cfg->{umask_etc});
    $self->_create_file("$Mailfull::Core::Cfg->{path_maildirs}", $Mailfull::Core::Cfg->{umask_etc});
    $self->_create_file("$Mailfull::Core::Cfg->{path_localtable}", $Mailfull::Core::Cfg->{umask_etc});
    $self->_create_file("$Mailfull::Core::Cfg->{path_forwards}", $Mailfull::Core::Cfg->{umask_etc});
    $self->_create_file("$Mailfull::Core::Cfg->{path_passwds}", $Mailfull::Core::Cfg->{umask_etc});

    print "make cdb files\n";
    Mailfull::Database->createdb;
}


sub _create_dir {
    my $self = shift;
    my ($path, $umask) = @_;

    unless ( -d "$path" ) {
        print "create dir  $path\n";
        Mailfull::Utils::File->mkdir($path, $umask);
    } else {
        print "create dir  $path   ...already exist\n";
    }
}


sub _create_file {
    my $self = shift;
    my ($path, $umask) = @_;

    unless ( -f "$path" ) {
        print "create file $path\n";
        Mailfull::Utils::File->touch($path, $umask);
    } else {
        print "create file $path   ...already exist\n";
    }
}


1;

