package Mailfull::Common::Error;

use strict;
use warnings;
use diagnostics;


sub get_message {
    my $self = shift;
    my ($val) = @_;

    my %messages = (
        # 10x domain
        101 => 'a domain is invalid format.',
        102 => 'a domain is not exist.',
        103 => 'a domain is already exist.',
        106 => 'a domain is set as aliasdomain target.',

        # 20x user
        201 => 'a username is invalid format.',
        202 => 'a user is not exist.',
        203 => 'a user is already exist.',
        204 => 'a user is already exist as aliasname.',
        205 => 'cannot delete postmaster.',
        206 => 'a user is set as catchall target.',

        # 30x catchall user
        301 => 'a catchall user is invalid format.',
        302 => 'a catchall user is not exist in this domain.',
        303 => 'a catchall user is already exist in this domain.',

        # 40x alias
        401 => 'a aliasname is invalid format.',
        402 => 'a aliasname is not exist.',
        403 => 'a aliasname is already exist.',
        404 => 'a aliasname is already exist as user.',
        411 => 'a destination is invalid format.',
        412 => 'a destination not exist.',
        413 => 'a destination is already exist.',

        # 50x aliasdomain
        501 => 'a aliasdomain is invalid format.',
        502 => 'a aliasdomain is not exist.',
        503 => 'a aliasdomain is already exist.',

        # other
        0   => 'failure.',
        1   => 'success.',
        999 => 'error.',
    );

    my $ret_message;
    if ( defined($val) ) {
        $ret_message = $messages{$val};
    }
    unless ( $ret_message ) {
        $ret_message = '';
    }

    return $ret_message;
}


1;

