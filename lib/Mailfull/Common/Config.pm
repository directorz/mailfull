package Mailfull::Common::Config;

use strict;
use warnings;
use diagnostics;


sub load {
    # --- default value ------------

    my $username		= "mailfull";
    my $groupname		= "mailfull";

    my $dir_etc			= "/home/mailfull/etc";
    my $dir_data		= "/home/mailfull/domains";

    my $umask_etc		= 0022;
    my $umask_data		= 0077;

    my $bin_postalias		= "/usr/sbin/postalias";
    my $bin_postmap		= "/usr/sbin/postmap";

    # ------------------------------

    foreach my $i (@INC) {
        my $path = $i . '/Mailfull/Common/myconfig.pl';
        if ( -f $path ) {
            open(my $fh_in, '<', "$path") or die "$!:$path";
            my $text = join('', <$fh_in>);
            close($fh_in) or die "$!:$path";

            eval ($text);
            last;
        }
    }

    # ------------------------------

    my $cfg = {
        username		=> $username,
        groupname		=> $groupname,

        dir_etc			=> $dir_etc,
        dir_data		=> $dir_data,

        umask_etc		=> $umask_etc,
        umask_data		=> $umask_data,

        bin_postalias		=> $bin_postalias,
        bin_postmap		=> $bin_postmap,

        path_domains		=> "$dir_etc/domains",
        path_destinations	=> "$dir_etc/destinations",
        path_maildirs		=> "$dir_etc/maildirs",
        path_localtable		=> "$dir_etc/localtable",
        path_forwards		=> "$dir_etc/forwards",
        path_passwds		=> "$dir_etc/vpasswd",

        path_aliasdomains	=> "$dir_data/.valiasdomains",

        name_passwds		=> ".vpasswd",
        name_forwards		=> ".vforward",
        name_aliases		=> ".valiases",
        name_catchall		=> ".vcatchall",

        name_userforward	=> ".forward",

        path_lockfile		=> "/tmp/mailfull_lockfile",
    };

    return $cfg;
}


1;

