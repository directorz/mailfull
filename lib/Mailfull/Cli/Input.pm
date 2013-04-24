package Mailfull::Cli::Input;

use strict;
use warnings;
use diagnostics;


##############################
# input once, without echo back
##############################
sub read_noecho {
    my $self = shift;
    my ($message) = @_;

    my $str = "";

    system "stty -echo";

    while (1) {
        print "$message:";
        chomp($str = <STDIN>);
        print "\n";

        if ( ! $str eq "" ) {
            last;
        }
    }

    system "stty echo";

    return $str;
}


##############################
# input twice, without echo back
##############################
sub read_noecho_confirm {
    my $self = shift;
    my ($message) = @_;

    my $str1 = "";
    my $str2 = "";

    system "stty -echo";

    while (1) {
        print "$message:";
        chomp($str1 = <STDIN>);
        print "\n";

        print "Retype:";
        chomp($str2 = <STDIN>);
        print "\n";

        if ( ! $str1 eq "" && $str1 eq $str2 ) {
            last;
        } else {
            if ( $str1 eq "" && $str2 eq "" ) {
                print "Sorry, input is empty.\n";
            } else {
                print "Sorry, inputs do not match.\n";
            }
        }
    }

    system "stty echo";

    return $str1;
}


1;

