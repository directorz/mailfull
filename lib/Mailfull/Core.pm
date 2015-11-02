package Mailfull::Core;

use strict;
use warnings;
use diagnostics;

use Mailfull::Common::Config;
BEGIN {
    our $Cfg = Mailfull::Common::Config->load;
}

use Mailfull::Database;
use Mailfull::Utils::Locker;
use Mailfull::Utils::File;
use Mailfull::Utils::Check;
use Mailfull::Utils::Password;
use Mailfull::Utils::Backup;

our $VERSION = '1.0.0';


##############################
# database
##############################
sub commit {
    my $self = shift;

    Mailfull::Utils::Locker->my_lock;

    my %ret;
    $ret{'retval'} = eval {
        ### go
        Mailfull::Database->commit;

        return 1;
    };
    if ($@) {
        print STDERR $@;
        $ret{'retval'} = 999;
    }

    Mailfull::Utils::Locker->my_unlock;

    return \%ret;
}


sub createdb {
    my $self = shift;

    Mailfull::Utils::Locker->my_lock;

    my %ret;
    $ret{'retval'} = eval {
        ### go
        Mailfull::Database->createdb;

        return 1;
    };
    if ($@) {
        print STDERR $@;
        $ret{'retval'} = 999;
    }

    Mailfull::Utils::Locker->my_unlock;

    return \%ret;
}


##############################
# domain
##############################
sub domain_add {
    my $self = shift;
    my ($domain, $password) = @_;

    Mailfull::Utils::Locker->my_lock;

    my %ret;
    $ret{'retval'} = eval {
        ### check
        unless ( Mailfull::Utils::Check->domain_correct_format($domain) ) {
            return 101;
        }
        if ( Mailfull::Utils::Check->domain_exist($domain) ) {
            return 103;
        }

        ### go
        Mailfull::Utils::File->mkdir("$Mailfull::Core::Cfg->{dir_data}/$domain", $Mailfull::Core::Cfg->{umask_data});
        Mailfull::Utils::File->touch("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_aliases}", $Mailfull::Core::Cfg->{umask_data});
        Mailfull::Utils::File->touch("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_forwards}", $Mailfull::Core::Cfg->{umask_data});
        Mailfull::Utils::File->touch("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_passwds}", $Mailfull::Core::Cfg->{umask_data});
        Mailfull::Utils::File->touch("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_catchall}", $Mailfull::Core::Cfg->{umask_data});

        return 1;
    };
    if ($@) {
        print STDERR $@;
        $ret{'retval'} = 999;
    }

    Mailfull::Utils::Locker->my_unlock;

    # create postmaster
    if ( $ret{'retval'} == 1 ) {
        my %tmp_ret = %{$self->user_add($domain, "postmaster", $password)};
        $ret{'retval'} = $tmp_ret{'retval'};
    }

    return \%ret;
}


sub domain_del {
    my $self = shift;
    my ($domain) = @_;

    Mailfull::Utils::Locker->my_lock;

    my %ret;
    $ret{'retval'} = eval {
        ### check
        unless ( Mailfull::Utils::Check->domain_correct_format($domain) ) {
            return 101;
        }
        unless ( Mailfull::Utils::Check->domain_exist($domain) ) {
            return 102;
        }
        if ( Mailfull::Utils::Check->domain_is_aliasdomaintarget($domain) ) {
            return 106;
        }

        ### go
        Mailfull::Utils::Backup->backup_domain($domain);
        Mailfull::Database->commit;

        return 1;
    };
    if ($@) {
        print STDERR $@;
        $ret{'retval'} = 999;
    }

    Mailfull::Utils::Locker->my_unlock;

    return \%ret;
}


sub domains_get {
    my $self = shift;

    my %ret;
    $ret{'retval'} = eval {
        ### go
        my @domains = Mailfull::Utils::File->ls("$Mailfull::Core::Cfg->{dir_data}", "d");
        $ret{'ref_domains'} = \@domains;

        return 1;
    };
    if ($@) {
        print STDERR $@;
        $ret{'retval'} = 999;
    }

    return \%ret;
}


sub domain_disable {
    my $self = shift;
    my ($domain) = @_;

    Mailfull::Utils::Locker->my_lock;

    my %ret;
    $ret{'retval'} = eval {
        ### check
        unless ( Mailfull::Utils::Check->domain_correct_format($domain) ) {
            return 101;
        }
        if ( !Mailfull::Utils::Check->domain_exist($domain) ) {
            return 102;
        }
        ### go
        Mailfull::Utils::File->touch("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_disable}", $Mailfull::Core::Cfg->{umask_data});

        return 1;
    };

    if ($@) {
        print STDERR $@;
        $ret{'retval'} = 999;
    }

    Mailfull::Utils::Locker->my_unlock;

    return \%ret;
}

sub domain_enable {
    my $self = shift;
    my ($domain) = @_;

    Mailfull::Utils::Locker->my_lock;

    my %ret;
    $ret{'retval'} = eval {
        ### check
        unless ( Mailfull::Utils::Check->domain_correct_format($domain) ) {
            return 101;
        }
        if ( !Mailfull::Utils::Check->domain_exist($domain) ) {
            return 102;
        }
        ### go
        Mailfull::Utils::File->rm("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_disable}");

        return 1;
    };

    if ($@) {
        print STDERR $@;
        $ret{'retval'} = 999;
    }

    Mailfull::Utils::Locker->my_unlock;

    return \%ret;
}

##############################
# user
##############################
sub user_add {
    my $self = shift;
    my ($domain, $username, $password) = @_;

    Mailfull::Utils::Locker->my_lock;

    my %ret;
    $ret{'retval'} = eval {
        ### check
        unless ( Mailfull::Utils::Check->domain_correct_format($domain) ) {
            return 101;
        }
        unless ( Mailfull::Utils::Check->username_correct_format($username) ) {
            return 201;
        }
        unless ( Mailfull::Utils::Check->domain_exist($domain) ) {
            return 102;
        }
        if ( Mailfull::Utils::Check->username_exist($domain, $username) ) {
            return 203;
        }
        if ( Mailfull::Utils::Check->aliasname_exist($domain, $username) ) {
            return 204;
        }

        ### go
        my $hashedpassword = Mailfull::Utils::Password->make_hashedpassword("$password");

        Mailfull::Utils::File->mkdir("$Mailfull::Core::Cfg->{dir_data}/$domain/$username", $Mailfull::Core::Cfg->{umask_data});
        Mailfull::Utils::File->mkdir("$Mailfull::Core::Cfg->{dir_data}/$domain/$username/Maildir", $Mailfull::Core::Cfg->{umask_data});
        Mailfull::Utils::File->mkdir("$Mailfull::Core::Cfg->{dir_data}/$domain/$username/Maildir/cur", $Mailfull::Core::Cfg->{umask_data});
        Mailfull::Utils::File->mkdir("$Mailfull::Core::Cfg->{dir_data}/$domain/$username/Maildir/new", $Mailfull::Core::Cfg->{umask_data});
        Mailfull::Utils::File->mkdir("$Mailfull::Core::Cfg->{dir_data}/$domain/$username/Maildir/tmp", $Mailfull::Core::Cfg->{umask_data});
        Mailfull::Utils::File->touch("$Mailfull::Core::Cfg->{dir_data}/$domain/$username/$Mailfull::Core::Cfg->{name_userforward}", $Mailfull::Core::Cfg->{umask_data});

        my %hash1 = %{Mailfull::Utils::File->file2hash("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_passwds}", ':')};
        $hash1{"$username"} = $hashedpassword;
        Mailfull::Utils::File->hash2file("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_passwds}", ':', \%hash1);

        my %hash2 = %{Mailfull::Utils::File->file2hash("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_forwards}", ':')};
        $hash2{"$username"} = '';
        Mailfull::Utils::File->hash2file("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_forwards}", ':', \%hash2);

        return 1;
    };
    if ($@) {
        print STDERR $@;
        $ret{'retval'} = 999;
    }

    Mailfull::Utils::Locker->my_unlock;

    return \%ret;
}


sub user_del {
    my $self = shift;
    my ($domain, $username) = @_;

    Mailfull::Utils::Locker->my_lock;

    my %ret;
    $ret{'retval'} = eval {
        ### check
        unless ( Mailfull::Utils::Check->domain_correct_format($domain) ) {
            return 101;
        }
        unless ( Mailfull::Utils::Check->username_correct_format($username) ) {
            return 201;
        }
        unless ( Mailfull::Utils::Check->domain_exist($domain) ) {
            return 102;
        }
        unless ( Mailfull::Utils::Check->username_exist($domain, $username) ) {
            return 202;
        }
        if ( $username eq "postmaster" ) {
            return 205;
        }
        if ( Mailfull::Utils::Check->username_is_catchalltarget($domain, $username) ) {
            return 206;
        }

        ### go
        my %hash1 = %{Mailfull::Utils::File->file2hash("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_passwds}", ':')};
        delete($hash1{"$username"});
        Mailfull::Utils::File->hash2file("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_passwds}", ':', \%hash1);

        my %hash2 = %{Mailfull::Utils::File->file2hash("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_forwards}", ':')};
        delete($hash2{"$username"});
        Mailfull::Utils::File->hash2file("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_forwards}", ':', \%hash2);

        Mailfull::Utils::Backup->backup_user($username, $domain);
        Mailfull::Database->commit;

        return 1;
    };
    if ($@) {
        print STDERR $@;
        $ret{'retval'} = 999;
    }

    Mailfull::Utils::Locker->my_unlock;

    return \%ret;
}


sub users_get {
    my $self = shift;
    my ($domain) = @_;

    my %ret;
    $ret{'retval'} = eval {
        ### check
        unless ( Mailfull::Utils::Check->domain_correct_format($domain) ) {
            return 101;
        }
        unless ( Mailfull::Utils::Check->domain_exist($domain) ) {
            return 102;
        }

        ### go
        my @users = Mailfull::Utils::File->ls("$Mailfull::Core::Cfg->{dir_data}/$domain", "d");
        $ret{'ref_users'} = \@users;

        return 1;
    };
    if ($@) {
        print STDERR $@;
        $ret{'retval'} = 999;
    }

    return \%ret;
}


sub user_changepasswd {
    my $self = shift;
    my ($domain, $username, $password) = @_;

    Mailfull::Utils::Locker->my_lock;

    my %ret;
    $ret{'retval'} = eval {
        ### check
        unless ( Mailfull::Utils::Check->domain_correct_format($domain) ) {
            return 101;
        }
        unless ( Mailfull::Utils::Check->username_correct_format($username) ) {
            return 201;
        }
        unless ( Mailfull::Utils::Check->domain_exist($domain) ) {
            return 102;
        }
        unless ( Mailfull::Utils::Check->username_exist($domain, $username) ) {
            return 202;
        }

        ### go
        my $hashedpassword = Mailfull::Utils::Password->make_hashedpassword("$password");

        my %hash = %{Mailfull::Utils::File->file2hash("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_passwds}", ':')};
        $hash{"$username"} = $hashedpassword;
        Mailfull::Utils::File->hash2file("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_passwds}", ':', \%hash);

        return 1;
    };
    if ($@) {
        print STDERR $@;
        $ret{'retval'} = 999;
    }

    Mailfull::Utils::Locker->my_unlock;

    return \%ret;
}


sub user_checkpasswd {
    my $self = shift;
    my ($domain, $username, $password) = @_;

    my %ret;
    $ret{'retval'} = eval {
        ### check
        unless ( Mailfull::Utils::Check->domain_exist($domain) ) {
            return 0;
        }

        ### go
        my %hash = %{Mailfull::Utils::File->file2hash("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_passwds}", ':')};

        my $hashedpassword;
        if ( exists($hash{"$username"}) ) {
            $hashedpassword = $hash{"$username"};
        } else {
            return 0;
        }

        if ( Mailfull::Utils::Password->check_hashedpassword("$hashedpassword", "$password") ) {
            return 1;
        } else {
            return 0;
        }
    };
    if ($@) {
        print STDERR $@;
        $ret{'retval'} = 999;
    }

    return \%ret;
}


##############################
# catchall
##############################
sub catchall_set {
    my $self = shift;
    my ($domain, $username) = @_;

    Mailfull::Utils::Locker->my_lock;

    my %ret;
    $ret{'retval'} = eval {
        ### check
        unless ( Mailfull::Utils::Check->domain_correct_format($domain) ) {
            return 101;
        }
        unless ( Mailfull::Utils::Check->username_correct_format($username) ) {
            return 201;
        }
        unless ( Mailfull::Utils::Check->domain_exist($domain) ) {
            return 102;
        }
        if ( Mailfull::Utils::Check->catchall_exist($domain) ) {
            return 303;
        }
        unless ( Mailfull::Utils::Check->username_exist($domain, $username) ) {
            return 202;
        }

        ### go
        my @lines = ("$username");
        Mailfull::Utils::File->array2file("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_catchall}", \@lines);

        return 1;
    };
    if ($@) {
        print STDERR $@;
        $ret{'retval'} = 999;
    }

    Mailfull::Utils::Locker->my_unlock;

    return \%ret;
}


sub catchall_del {
    my $self = shift;
    my ($domain) = @_;

    Mailfull::Utils::Locker->my_lock;

    my %ret;
    $ret{'retval'} = eval {
        ### check
        unless ( Mailfull::Utils::Check->domain_correct_format($domain) ) {
            return 101;
        }
        unless ( Mailfull::Utils::Check->domain_exist($domain) ) {
            return 102;
        }
        unless ( Mailfull::Utils::Check->catchall_exist($domain) ) {
            return 302;
        }

        ### go
        my @empty = ();
        Mailfull::Utils::File->array2file("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_catchall}", \@empty);

        return 1;
    };
    if ($@) {
        print STDERR $@;
        $ret{'retval'} = 999;
    }

    Mailfull::Utils::Locker->my_unlock;

    return \%ret;
}


sub catchall_get {
    my $self = shift;
    my ($domain) = @_;

    my %ret;
    $ret{'retval'} = eval {
        ### check
        unless ( Mailfull::Utils::Check->domain_correct_format($domain) ) {
            return 101;
        }
        unless ( Mailfull::Utils::Check->domain_exist($domain) ) {
            return 102;
        }
        unless ( Mailfull::Utils::Check->catchall_exist($domain) ) {
            return 302;
        }

        ### go
        my @lines = @{Mailfull::Utils::File->file2array("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_catchall}")};
        $ret{'user_catchall'} = $lines[0];

        return 1;
    };
    if ($@) {
        print STDERR $@;
        $ret{'retval'} = 999;
    }

    return \%ret;
}


##############################
# alias
##############################
sub alias_add {
    my $self = shift;
    my ($domain, $aliasname, $ref_aliasdests) = @_;

    my %ret;
    $ret{'retval'} = eval {
        ### check
        unless ( Mailfull::Utils::Check->domain_correct_format($domain) ) {
            return 101;
        }
        unless ( Mailfull::Utils::Check->domain_exist($domain) ) {
            return 102;
        }

        ### go
        my %hash_aliases = %{Mailfull::Utils::File->file2hash("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_aliases}", ':')};

        my @aliasdests_addition = @{$ref_aliasdests};

        my @aliasdests_now = ();
        if ( exists($hash_aliases{"$aliasname"}) ) {
            @aliasdests_now = split(/,/, $hash_aliases{"$aliasname"});
        }

        # merge
        my %cnt = ();
        my @aliasdests = grep { ++$cnt{$_} == 1 } (@aliasdests_now, @aliasdests_addition);

        %ret = %{$self->alias_set($domain, $aliasname, \@aliasdests)};

        return $ret{'retval'};
    };
    if ($@) {
        print STDERR $@;
        $ret{'retval'} = 999;
    }

    return \%ret;
}


sub alias_del {
    my $self = shift;
    my ($domain, $aliasname, $ref_aliasdests) = @_;

    my %ret;
    $ret{'retval'} = eval {
        ### check
        unless ( Mailfull::Utils::Check->domain_correct_format($domain) ) {
            return 101;
        }
        unless ( Mailfull::Utils::Check->domain_exist($domain) ) {
            return 102;
        }

        ### go
        my %hash_aliases = %{Mailfull::Utils::File->file2hash("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_aliases}", ':')};

        my @aliasdests_deletion = @{$ref_aliasdests};

        my @aliasdests_now = ();
        if ( exists($hash_aliases{"$aliasname"}) ) {
            @aliasdests_now = split(/,/, $hash_aliases{"$aliasname"});
        }

        # sub
        my %cnt = ();
        map { $cnt{$_}-- } @aliasdests_deletion;
        my @aliasdests = grep { ++$cnt{$_} == 1 } @aliasdests_now;

        %ret = %{$self->alias_set($domain, $aliasname, \@aliasdests)};

        return $ret{'retval'};
    };
    if ($@) {
        print STDERR $@;
        $ret{'retval'} = 999;
    }

    return \%ret;
}


sub alias_set {
    my $self = shift;
    my ($domain, $aliasname, $ref_aliasdests) = @_;

    Mailfull::Utils::Locker->my_lock;

    my %ret;
    $ret{'retval'} = eval {
        ### check
        unless ( Mailfull::Utils::Check->domain_correct_format($domain) ) {
            return 101;
        }
        unless ( Mailfull::Utils::Check->aliasname_correct_format($aliasname) ) {
            return 401;
        }
        unless ( Mailfull::Utils::Check->domain_exist($domain) ) {
            return 102;
        }
        if ( Mailfull::Utils::Check->username_exist($domain, $aliasname) ) {
            return 404;
        }

        ### go
        my %hash_aliases = %{Mailfull::Utils::File->file2hash("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_aliases}", ':')};

        my @aliasdests = @{$ref_aliasdests};

        if (@aliasdests) {
            foreach my $dest (@aliasdests) {
                # check
                unless ( Mailfull::Utils::Check->aliasdest_correct_format($dest) ) {
                    $ret{'err_dest'} = $dest;
                    return 411;
                }
            }

            $hash_aliases{"$aliasname"} = join(',', @aliasdests);
        } else {
            # delete aliasname if dests
            delete($hash_aliases{"$aliasname"});
        }

        Mailfull::Utils::File->hash2file("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_aliases}", ':', \%hash_aliases);

        return 1;
    };
    if ($@) {
        print STDERR $@;
        $ret{'retval'} = 999;
    }

    Mailfull::Utils::Locker->my_unlock;

    return \%ret;
}


sub aliasnames_get {
    my $self = shift;
    my ($domain) = @_;

    my %ret;
    $ret{'retval'} = eval {
        ### check
        unless ( Mailfull::Utils::Check->domain_correct_format($domain) ) {
            return 101;
        }
        unless ( Mailfull::Utils::Check->domain_exist($domain) ) {
            return 102;
        }

        ### go
        my %hash_aliases = %{Mailfull::Utils::File->file2hash("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_aliases}", ':')};

        my @aliasnames = sort keys %hash_aliases;
        $ret{'ref_aliasnames'} = \@aliasnames;

        return 1;
    };
    if ($@) {
        print STDERR $@;
        $ret{'retval'} = 999;
    }

    return \%ret;
}


sub aliasdests_get {
    my $self = shift;
    my ($domain, $aliasname) = @_;

    my %ret;
    $ret{'retval'} = eval {
        ### check
        unless ( Mailfull::Utils::Check->domain_correct_format($domain) ) {
            return 101;
        }
        unless ( Mailfull::Utils::Check->aliasname_correct_format($aliasname) ) {
            return 401;
        }
        unless ( Mailfull::Utils::Check->domain_exist($domain) ) {
            return 102;
        }
        unless ( Mailfull::Utils::Check->aliasname_exist($domain, $aliasname) ) {
            return 402;
        }

        ### go
        my %hash_aliases = %{Mailfull::Utils::File->file2hash("$Mailfull::Core::Cfg->{dir_data}/$domain/$Mailfull::Core::Cfg->{name_aliases}", ':')};

        my @aliasdests = ();
        if ( exists($hash_aliases{"$aliasname"}) ) {
            @aliasdests = split(/,/, $hash_aliases{"$aliasname"})
        }

        $ret{'ref_aliasdests'} = \@aliasdests;

        return 1;
    };
    if ($@) {
        print STDERR $@;
        $ret{'retval'} = 999;
    }

    return \%ret;
}


##############################
# aliasdomain
##############################
sub aliasdomain_add {
    my $self = shift;
    my ($aliasdomain, $domain) = @_;

    Mailfull::Utils::Locker->my_lock;

    my %ret;
    $ret{'retval'} = eval {
        ### check
        unless ( Mailfull::Utils::Check->aliasdomain_correct_format($aliasdomain) ) {
            return 501;
        }
        unless ( Mailfull::Utils::Check->domain_correct_format($domain) ) {
            return 101;
        }
        unless ( Mailfull::Utils::Check->domain_exist($domain) ) {
            return 102;
        }
        if ( Mailfull::Utils::Check->aliasdomain_exist($aliasdomain) ) {
            return 503;
        }

        ### go
        my %hash = %{Mailfull::Utils::File->file2hash("$Mailfull::Core::Cfg->{path_aliasdomains}", ':')};
        $hash{"$aliasdomain"} = $domain;
        Mailfull::Utils::File->hash2file("$Mailfull::Core::Cfg->{path_aliasdomains}", ':', \%hash);

        return 1
    };
    if ($@) {
        print STDERR $@;
        $ret{'retval'} = 999;
    }

    Mailfull::Utils::Locker->my_unlock;

    return \%ret;
}


sub aliasdomain_del {
    my $self = shift;
    my ($aliasdomain) = @_;

    Mailfull::Utils::Locker->my_lock;

    my %ret;
    $ret{'retval'} = eval {
        ### check
        unless ( Mailfull::Utils::Check->aliasdomain_correct_format($aliasdomain) ) {
            return 501;
        }
        unless ( Mailfull::Utils::Check->aliasdomain_exist($aliasdomain) ) {
            return 502;
        }

        ### go
        my %hash = %{Mailfull::Utils::File->file2hash("$Mailfull::Core::Cfg->{path_aliasdomains}", ':')};
        delete($hash{"$aliasdomain"});
        Mailfull::Utils::File->hash2file("$Mailfull::Core::Cfg->{path_aliasdomains}", ':', \%hash);

        return 1;
    };
    if ($@) {
        print STDERR $@;
        $ret{'retval'} = 999;
    }

    Mailfull::Utils::Locker->my_unlock;

    return \%ret;
}


sub aliasdomains_get {
    my $self = shift;
    my ($domain) = @_;

    my %ret;
    $ret{'retval'} = eval {
        ### check
        unless ( Mailfull::Utils::Check->domain_correct_format($domain) ) {
            return 101;
        }

        ### go
        my %hash = %{Mailfull::Utils::File->file2hash("$Mailfull::Core::Cfg->{path_aliasdomains}", ':')};

        my @aliasdomains = ();
        foreach my $key ( sort keys %hash ) {
            push(@aliasdomains, $key) if $domain eq $hash{"$key"};
        }

        $ret{'ref_aliasdomains'} = \@aliasdomains;

        return 1;
    };
    if ($@) {
        print STDERR $@;
        $ret{'retval'} = 999;
    }

    return \%ret;
}


1;

