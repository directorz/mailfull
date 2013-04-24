package Mailfull::Utils::Password;

use strict;
use warnings;
use diagnostics;
use Digest::SHA1 qw(sha1);
use MIME::Base64;


##############################
# make hashed password
##############################
sub make_hashedpassword {
    my $self = shift;
    my ($password) = @_;

    my $salt = $self->_make_salt;
    my $hash = sha1($password . $salt);
    my $hashedpassword = encode_base64($hash . $salt, '');

    return '{SSHA}' . $hashedpassword;
}


##############################
# check password
##############################
sub check_hashedpassword {
    my $self = shift;
    my ($hashedpassword, $password) = @_;

    $hashedpassword =~ s/^.*\{SSHA\}//;

    unless ( length($hashedpassword) == 32 ) {
        return;
    }

    my ($hash, $salt) = unpack("a20a*", decode_base64($hashedpassword));
    my $tmp_hash = sha1($password . $salt);

    if ($hash eq $tmp_hash) {
        return 1;
    } else {
        return;
    }
}


##############################
# make salt
##############################
sub _make_salt {
    my $self = shift;

    my @strs = ('.', '/', 0..9, 'A'..'Z', 'a'..'z');
    srand(time + $$);
    my $salt = join('', @strs[map {rand 64} (1..4)]);

    return $salt;
}


1;

