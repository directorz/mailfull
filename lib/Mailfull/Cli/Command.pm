package Mailfull::Cli::Command;

use strict;
use warnings;
use diagnostics;
use File::Basename;

use Mailfull::Core;
use Mailfull::Cli::Input;
use Mailfull::Cli::Usage;
use Mailfull::Common::Error;
use Mailfull::Setup;


# switch subroutine
sub _switcher {
    my $self = shift;

    # get command name
    my $commandname = basename($0);

    # show usage
    if ( defined($ARGV[0]) && $ARGV[0] eq '-h' ) {
        print Mailfull::Cli::Usage->$commandname;
        exit 0;
    }

    # show version
    if ( defined($ARGV[0]) && $ARGV[0] eq '-v' ) {
        print $Mailfull::Core::VERSION . "\n";
        exit 0;
    }

    # call subroutine
    $self->$commandname(@ARGV);
}


# loader
sub loader {
    my $self = shift;

    print STDERR Mailfull::Cli::Usage->loader;
    exit 1;
}


# --------------------------------------------------


##############################
# setup
##############################
sub setup {
    my $self = shift;

    eval {
        Mailfull::Setup->setup;
    };
    unless ($@) {
        exit 0;
    } else {
        exit 1;
    }
}


# --------------------------------------------------


##############################
# database
##############################
sub commit {
    my $self = shift;
    my ($arg) = @_;

    ### go
    my $retval;
    if ( defined($arg) && $arg eq '-g' ) {
        my $ref_ret = Mailfull::Core->createdb;
        $retval = $$ref_ret{'retval'};
    } else {
        my $ref_ret = Mailfull::Core->commit;
        $retval = $$ref_ret{'retval'};
    }

    if ( $retval == 1 ) {
        exit 0;
    } else {
        print STDERR Mailfull::Common::Error->get_message($retval) . "\n";
        exit $retval;
    }
}


##############################
# domain
##############################
sub vdomainadd {
    my $self = shift;
    my ($domain, $password) = @_;

    ### argcheck
    if ( ! defined($domain) || $domain eq "" ) {
        print STDERR Mailfull::Cli::Usage->vdomainadd;
        exit 1;
    }

    my $password_postmaster = "";
    if ( defined($password) ) {
        $password_postmaster = $password;
    } else {
        $password_postmaster = Mailfull::Cli::Input->read_noecho_confirm("Enter password for postmaster\@$domain");
    }

    ### go
    my $ref_ret = Mailfull::Core->domain_add($domain, $password_postmaster);
    my $retval = $$ref_ret{'retval'};

    if ( $retval == 1 ) {
        exit 0;
    } else {
        print STDERR Mailfull::Common::Error->get_message($retval) . "\n";
        exit $retval;
    }
}


sub vdomaindel {
    my $self = shift;
    my ($domain) = @_;

    ### argcheck
    if ( ! defined($domain) || $domain eq "" ) {
        print STDERR Mailfull::Cli::Usage->vdomaindel;
        exit 1;
    }

    ### go
    my $ref_ret = Mailfull::Core->domain_del($domain);
    my $retval = $$ref_ret{'retval'};

    if ( $retval == 1 ) {
        exit 0;
    } else {
        print STDERR Mailfull::Common::Error->get_message($retval) . "\n";
        exit $retval;
    }
}


sub vdomainlist {
    my $self = shift;

    ### go
    my $ref_ret = Mailfull::Core->domains_get;
    my $retval = $$ref_ret{'retval'};

    if ( $retval == 1 ) {
        my @domains = @{$$ref_ret{'ref_domains'}};
        print join("\n", sort(@domains)) . "\n";
        exit 0;
    } else {
        print STDERR Mailfull::Common::Error->get_message($retval) . "\n";
        exit $retval;
    }
}

sub vdomaindisable {
    my $self = shift;
    my ($domain) = @_;

    ### argcheck
    if ( ! defined($domain) || $domain eq "" ) {
        print STDERR Mailfull::Cli::Usage->vdomainadd;
        exit 1;
    }

    ### go
    my $ref_ret = Mailfull::Core->domain_disable($domain);
    my $retval = $$ref_ret{'retval'};

    if ( $retval == 1 ) {
        exit 0;
    } else {
        print STDERR Mailfull::Common::Error->get_message($retval) . "\n";
        exit $retval;
    }
}

sub vdomainenable {
    my $self = shift;
    my ($domain) = @_;

    ### argcheck
    if ( ! defined($domain) || $domain eq "" ) {
        print STDERR Mailfull::Cli::Usage->vdomainadd;
        exit 1;
    }

    ### go
    my $ref_ret = Mailfull::Core->domain_enable($domain);
    my $retval = $$ref_ret{'retval'};

    if ( $retval == 1 ) {
        exit 0;
    } else {
        print STDERR Mailfull::Common::Error->get_message($retval) . "\n";
        exit $retval;
    }
}


##############################
# user
##############################
sub vuseradd {
    my $self = shift;
    my ($address, $password) = @_;

    ### argcheck
    if ( ! defined($address) || $address !~ /.+@.+/ ) {
        print STDERR Mailfull::Cli::Usage->vuseradd;
        exit 1;
    }

    my ($username, $domain) = split(/@/, $address);

    my $password_user = "";
    if ( defined($password) ) {
        $password_user = $password;
    } else {
        $password_user = Mailfull::Cli::Input->read_noecho_confirm("Enter password for $username\@$domain");
    }

    ### go
    my $ref_ret = Mailfull::Core->user_add($domain, $username, $password_user);
    my $retval = $$ref_ret{'retval'};

    if ( $retval == 1 ) {
        exit 0;
    } else {
        print STDERR Mailfull::Common::Error->get_message($retval) . "\n";
        exit $retval;
    }
}


sub vuserdel {
    my $self = shift;
    my ($address) = @_;

    ### argcheck
    if ( ! defined($address) || $address !~ /.+@.+/ ) {
        print STDERR Mailfull::Cli::Usage->vuserdel;
        exit 1;
    }

    my ($username, $domain) = split(/@/, $address);

    ### go
    my $ref_ret = Mailfull::Core->user_del($domain, $username);
    my $retval = $$ref_ret{'retval'};

    if ( $retval == 1 ) {
        exit 0;
    } else {
        print STDERR Mailfull::Common::Error->get_message($retval) . "\n";
        exit $retval;
    }
}


sub vuserlist {
    my $self = shift;
    my ($domain) = @_;

    ### argcheck
    if ( ! defined($domain) || $domain eq "" ) {
        print STDERR Mailfull::Cli::Usage->vuserlist;
        exit 1;
    }

    ### go
    my $ref_ret = Mailfull::Core->users_get($domain);
    my $retval = $$ref_ret{'retval'};

    if ( $retval == 1 ) {
        my @users = @{$$ref_ret{'ref_users'}};
        print join("\n", sort(@users)) . "\n";
        exit 0;
    } else {
        print STDERR Mailfull::Common::Error->get_message($retval) . "\n";
        exit $retval;
    }
}


sub vuserpasswd {
    my $self = shift;
    my ($address, $password) = @_;

    ### argcheck
    if ( ! defined($address) || $address !~ /.+@.+/ ) {
        print STDERR Mailfull::Cli::Usage->vuserpasswd;
        exit 1;
    }

    my ($username, $domain) = split(/@/, $address);

    my $password_user = "";
    if ( defined($password) ) {
        $password_user = $password;
    } else {
        $password_user = Mailfull::Cli::Input->read_noecho_confirm("Enter password for $username\@$domain");
    }

    ### go
    my $ref_ret = Mailfull::Core->user_changepasswd($domain, $username, $password_user);
    my $retval = $$ref_ret{'retval'};

    if ( $retval == 1 ) {
        exit 0;
    } else {
        print STDERR Mailfull::Common::Error->get_message($retval) . "\n";
        exit $retval;
    }
}


sub vusercheckpw {
    my $self = shift;
    my ($address, $password) = @_;

    ### argcheck
    if ( ! defined($address) || $address !~ /.+@.+/ ) {
        print STDERR Mailfull::Cli::Usage->vusercheckpw;
        exit 1;
    }

    my ($username, $domain) = split(/@/, $address);

    my $password_user = "";
    if ( defined($password) ) {
        $password_user = $password;
    } else {
        $password_user = Mailfull::Cli::Input->read_noecho("Enter password for $username\@$domain");
    }

    ### go
    my $ref_ret = Mailfull::Core->user_checkpasswd($domain, $username, $password_user);
    my $retval = $$ref_ret{'retval'};

    if ( $retval == 1 ) {
        print "password is correct.\n";
        exit 0;
    } elsif ( $retval == 0 ) {
        print "password or username is incorrect.\n";
        exit 1;
    } else {
        print STDERR Mailfull::Common::Error->get_message($retval) . "\n";
        exit $retval;
    }
}


##############################
# catchall
##############################
sub vcatchallset {
    my $self = shift;
    my ($domain, $username) = @_;

    ### argcheck
    if ( ! defined($domain) || $domain eq "" || ! defined($username) || $username eq "" ) {
        print STDERR Mailfull::Cli::Usage->vcatchallset;
        exit 1;
    }

    ### go
    my $ref_ret = Mailfull::Core->catchall_set($domain, $username);
    my $retval = $$ref_ret{'retval'};

    if ( $retval == 1 ) {
        exit 0;
    } else {
        print STDERR Mailfull::Common::Error->get_message($retval) . "\n";
        exit $retval;
    }
}


sub vcatchalldel {
    my $self = shift;
    my ($domain) = @_;

    ### argcheck
    if ( ! defined($domain) || $domain eq "" ) {
        print STDERR Mailfull::Cli::Usage->vcatchalldel;
        exit 1;
    }

    ### go
    my $ref_ret = Mailfull::Core->catchall_del($domain);
    my $retval = $$ref_ret{'retval'};

    if ( $retval == 1 ) {
        exit 0;
    } else {
        print STDERR Mailfull::Common::Error->get_message($retval) . "\n";
        exit $retval;
    }
}


sub vcatchallget {
    my $self = shift;
    my ($domain) = @_;

    ### argcheck
    if ( ! defined($domain) || $domain eq "" ) {
        print STDERR Mailfull::Cli::Usage->vcatchallget;
        exit 1;
    }

    ### go
    my $ref_ret = Mailfull::Core->catchall_get($domain);
    my $retval = $$ref_ret{'retval'};

    if ( $retval == 1 ) {
        my $user_catchall = $$ref_ret{'user_catchall'};
        print $user_catchall . "\n";
        exit 0;
    } else {
        print STDERR Mailfull::Common::Error->get_message($retval) . "\n";
        exit $retval;
    }
}


##############################
# alias
##############################
sub valiasset {
    my $self = shift;
    my ($mode, $address, $dests) = @_;

    ### argcheck
    if ( ! defined($mode) || ! defined($address) || $address !~ /.+@.+/ || ! defined($dests) ) {
        print STDERR Mailfull::Cli::Usage->valiasset;
        exit 1;
    }

    my ($aliasname, $domain) = split(/@/, $address);
    my @array_dests = split(/,/, $dests);

    if ( $mode eq '-a' ) {
        ### go
        my $ref_ret = Mailfull::Core->alias_add($domain, $aliasname, \@array_dests);
        my $retval = $$ref_ret{'retval'};

        if ( $retval == 1 ) {
            exit 0;
        } else {
            print STDERR Mailfull::Common::Error->get_message($retval) . "\n";
            exit $retval;
        }
    } elsif ( $mode eq '-r' ) {
        ### go
        my $ref_ret = Mailfull::Core->alias_set($domain, $aliasname, \@array_dests);
        my $retval = $$ref_ret{'retval'};

        if ( $retval == 1 ) {
            exit 0;
        } else {
            print STDERR Mailfull::Common::Error->get_message($retval) . "\n";
            exit $retval;
        }
    } else {
        print STDERR Mailfull::Cli::Usage->valiasset;
        exit 1;
    }
}


sub valiasdel {
    my $self = shift;
    my ($mode, $address, $dests) = @_;

    ### argcheck
    if ( ! defined($mode) || ! defined($address) || $address !~ /.+@.+/ ) {
        print STDERR Mailfull::Cli::Usage->valiasdel;
        exit 1;
    }

    my ($aliasname, $domain) = split(/@/, $address);

    if ( $mode eq '-d' ) {
        ### argcheck
        if ( ! defined($dests) ) {
            print STDERR Mailfull::Cli::Usage->valiasdel;
            exit 1;
        }

        my @array_dests = split(/,/, $dests);

        ### go
        my $ref_ret = Mailfull::Core->alias_del($domain, $aliasname, \@array_dests);
        my $retval = $$ref_ret{'retval'};

        if ( $retval == 1 ) {
            exit 0;
        } else {
            print STDERR Mailfull::Common::Error->get_message($retval) . "\n";
            exit $retval;
        }
    } elsif ( $mode eq '-a' ) {
        ### go
        my @empty = ();
        my $ref_ret = Mailfull::Core->alias_set($domain, $aliasname, \@empty);
        my $retval = $$ref_ret{'retval'};

        if ( $retval == 1 ) {
            exit 0;
        } else {
            print STDERR Mailfull::Common::Error->get_message($retval) . "\n";
            exit $retval;
        }
    } else {
        print STDERR Mailfull::Cli::Usage->valiasdel;
        exit 1;
    }
}


sub valiaslist {
    my $self = shift;
    my ($arg) = @_;

    ### argcheck
    if ( ! defined($arg) || $arg eq "" ) {
        print STDERR Mailfull::Cli::Usage->valiaslist;
        exit 1;
    }

    if ( $arg !~ /.+@.+/ ) {
        # show aliasnames
        my $domain = $arg;

        ### go
        my $ref_ret = Mailfull::Core->aliasnames_get($domain);
        my $retval = $$ref_ret{'retval'};

        if ( $retval == 1 ) {
            my @list = @{$$ref_ret{'ref_aliasnames'}};
            print join("\n", sort(@list)) . "\n";
            exit 0;
        } else {
            print STDERR Mailfull::Common::Error->get_message($retval) . "\n";
            exit $retval;
        }
    } else {
        # show aliasdests
        my ($aliasname, $domain) = split(/@/, $arg);

        ### go
        my $ref_ret = Mailfull::Core->aliasdests_get($domain, $aliasname);
        my $retval = $$ref_ret{'retval'};

        if ( $retval == 1 ) {
            my @list = @{$$ref_ret{'ref_aliasdests'}};
            print join("\n", sort(@list)) . "\n";
            exit 0;
        } else {
            print STDERR Mailfull::Common::Error->get_message($retval) . "\n";
            exit $retval;
        }
    }
}


##############################
# aliasdomain
##############################
sub valiasdomainadd {
    my $self = shift;
    my ($aliasdomain, $domain) = @_;

    ### argcheck
    if ( ! defined($aliasdomain) || $aliasdomain eq "" || ! defined($domain) || $domain eq "" ) {
        print STDERR Mailfull::Cli::Usage->valiasdomainadd;
        exit 1;
    }

    ### go
    my $ref_ret = Mailfull::Core->aliasdomain_add($aliasdomain, $domain);
    my $retval = $$ref_ret{'retval'};

    if ( $retval == 1 ) {
        exit 0;
    } else {
        print STDERR Mailfull::Common::Error->get_message($retval) . "\n";
        exit $retval;
    }
}


sub valiasdomaindel {
    my $self = shift;
    my ($aliasdomain) = @_;

    ### argcheck
    if ( ! defined($aliasdomain) || $aliasdomain eq "" ) {
        print STDERR Mailfull::Cli::Usage->valiasdomaindel;
        exit 1;
    }

    ### go
    my $ref_ret = Mailfull::Core->aliasdomain_del($aliasdomain);
    my $retval = $$ref_ret{'retval'};

    if ( $retval == 1 ) {
        exit 0;
    } else {
        print STDERR Mailfull::Common::Error->get_message($retval) . "\n";
        exit $retval;
    }
}


sub valiasdomainlist {
    my $self = shift;
    my ($domain) = @_;

    ### argcheck
    if ( ! defined($domain) || $domain eq "" ) {
        print STDERR Mailfull::Cli::Usage->valiasdomainlist;
        exit 1;
    }

    ### go
    my $ref_ret = Mailfull::Core->aliasdomains_get($domain);
    my $retval = $$ref_ret{'retval'};

    if ( $retval == 1 ) {
        my @aliasdomains = @{$$ref_ret{'ref_aliasdomains'}};
        print join("\n", sort(@aliasdomains)) . "\n";
        exit 0;
    } else {
        print STDERR Mailfull::Common::Error->get_message($retval) . "\n";
        exit $retval;
    }
}


1;

