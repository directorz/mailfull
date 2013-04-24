package Mailfull::Cli::Usage;

use strict;
use warnings;
use diagnostics;


sub loader {
    my $str = "";
    $str .= "this is the loader itself. exit with doing nothing.\n";

    return $str;
}


sub setup {
    my $str = "";
    $str .= "Usage:\n";
    $str .= "  setup\n";
    $str .= "\n";
    $str .= "show command to create group and user for mailfull.\n";
    $str .= "make initial dirs and files.\n";
    $str .= "generate postfix configuration.\n";
    $str .= "generate dovecot configuration.\n";

    return $str;
}


sub commit {
    my $str = "";
    $str .= "Usage:\n";
    $str .= "  commit [-g]\n";
    $str .= "\n";
    $str .= "generate confs and make cdb files.\n";
    $str .= "if \"-g\" given, only make cdb files.\n";

    return $str;
}


sub vdomainadd {
    my $str = "";
    $str .= "Usage:\n";
    $str .= "  vdomainadd example.com [postmasterpassword]\n";
    $str .= "\n";
    $str .= "add domain and postmaster.\n";
    $str .= "password can interactive input.\n";

    return $str;
}


sub vdomaindel {
    my $str = "";
    $str .= "Usage:\n";
    $str .= "  vdomaindel example.com\n";
    $str .= "\n";
    $str .= "delete domain and commit.\n";
    $str .= "domain dir will be backup. (example.com -> .example.com.YYYYMMDDHHMMSS)\n";

    return $str;
}


sub vdomainlist {
    my $str = "";
    $str .= "Usage:\n";
    $str .= "  vdomainlist\n";
    $str .= "\n";
    $str .= "show all domains.\n";

    return $str;
}


sub vuseradd {
    my $str = "";
    $str .= "Usage:\n";
    $str .= "  vuseradd user\@example.com [password]\n";
    $str .= "\n";
    $str .= "add user.\n";
    $str .= "password can interactive input.\n";

    return $str;
}


sub vuserdel {
    my $str = "";
    $str .= "Usage:\n";
    $str .= "  vuserdel user\@example.com\n";
    $str .= "\n";
    $str .= "delete user and commit.\n";
    $str .= "user dir will be backup. (example.com/user -> example.com/.user.YYYYMMDDHHMMSS)\n";

    return $str;
}


sub vuserlist {
    my $str = "";
    $str .= "Usage:\n";
    $str .= "  vuserlist example.com\n";
    $str .= "\n";
    $str .= "show all users from domain.\n";

    return $str;
}


sub vuserpasswd {
    my $str = "";
    $str .= "Usage:\n";
    $str .= "  vuserpasswd user\@example.com [password]\n";
    $str .= "\n";
    $str .= "change user password.\n";
    $str .= "password can interactive input.\n";

    return $str;
}


sub vusercheckpw {
    my $str = "";
    $str .= "Usage:\n";
    $str .= "  vusercheckpw user\@example.com [password]\n";
    $str .= "\n";
    $str .= "check user password.\n";
    $str .= "password can interactive input.\n";

    return $str;
}


sub vcatchallset {
    my $str = "";
    $str .= "Usage:\n";
    $str .= "  vcatchallset example.com user\n";
    $str .= "\n";
    $str .= "set catchall user.\n";

    return $str;
}


sub vcatchalldel {
    my $str = "";
    $str .= "Usage:\n";
    $str .= "  vcatchalldel example.com\n";
    $str .= "\n";
    $str .= "remove catchall user.\n";

    return $str;
}


sub vcatchallget {
    my $str = "";
    $str .= "Usage:\n";
    $str .= "  vcatchallget example.com\n";
    $str .= "\n";
    $str .= "show catchall user.\n";

    return $str;
}


sub valiasset {
    my $str = "";
    $str .= "Usage:\n";
    $str .= "  valiasset -a aliasname\@example.com dest\@example.org[,...]\n";
    $str .= "            (add destinations)\n";
    $str .= "  valiasset -r aliasname\@example.com dest\@example.org[,...]\n";
    $str .= "            (replace destinations)\n";

    return $str;
}


sub valiasdel {
    my $str = "";
    $str .= "Usage:\n";
    $str .= "  valiasdel -d aliasname\@example.com dest\@example.org[,...]\n";
    $str .= "            (delete destinations)\n";
    $str .= "  valiasdel -a aliasname\@example.com\n";
    $str .= "            (delete all destinations and delete aliasname)\n";

    return $str;
}


sub valiaslist {
    my $str = "";
    $str .= "Usage:\n";
    $str .= "  valiaslist example.com             (show all aliasnames)\n";
    $str .= "  valiaslist aliasname\@example.com   (show all destinations)\n";

    return $str;
}


sub valiasdomainadd {
    my $str = "";
    $str .= "Usage:\n";
    $str .= "  valiasdomainadd alias.example.com example.com\n";
    $str .= "\n";
    $str .= "add aliasdomain.\n";

    return $str;
}


sub valiasdomaindel {
    my $str = "";
    $str .= "Usage:\n";
    $str .= "  valiasdomaindel alias.example.com\n";
    $str .= "\n";
    $str .= "delete aliasdomain.\n";

    return $str;
}


sub valiasdomainlist {
    my $str = "";
    $str .= "Usage:\n";
    $str .= "  valiasdomainlist example.com\n";
    $str .= "\n";
    $str .= "show aliasdomains for domain.\n";

    return $str;
}


1;

