package Mailfull::Utils::File;

use strict;
use warnings;
use diagnostics;
use File::Path;


##############################
# mkdir
##############################
sub mkdir {
    my $self = shift;
    my ($path, $umask) = @_;

    if ( defined($umask) ) { umask($umask) }

    mkpath($path, 0) or die "$!:$path";

    $self->chown($path);
}


##############################
# mkdir
##############################
sub touch {
    my $self = shift;
    my ($file, $umask) = @_;

    if ( defined($umask) ) { umask($umask) }

    open(my $fh, '>', $file) or die "$!:$file";
    close($fh) or die "$!:$file";

    $self->chown($file);
}


##############################
# rm
##############################
sub rm {
    my $self = shift;
    my ($file) = @_;
    
    unlink $file or die "$!:$file";
}


##############################
# ls
##############################
sub ls {
    my $self = shift;
    my ($dir, $type) = @_;

    opendir(DIR, $dir) or die "$!:$dir";
    my @list = sort(readdir(DIR));

    @list = grep { ! /^\.\.?$/ } @list;
    @list = grep { ! /^\..*$/ } @list;

    closedir(DIR) or die "$!:$dir";

    if ( $type eq "d" ) { @list = grep { -d "$dir/$_" } @list }
    if ( $type eq "f" ) { @list = grep { -f "$dir/$_" } @list }

    return @list;
}


##############################
# chmod
##############################
sub chmod {
    my $self = shift;
    my ($mode, $path) = @_;

    chmod($mode, $path) or die "$!:$path";
}


##############################
# chown
##############################
sub chown {
    my $self = shift;
    my ($path) = @_;

    my $username = $Mailfull::Core::Cfg->{username};
    my $groupname = $Mailfull::Core::Cfg->{groupname};

    defined(my $uid = getpwnam $username) or die "no such user:$username";
    defined(my $gid = getgrnam $groupname) or die "no such group:$groupname";

    chown($uid, $gid, $path) or die "$!:$path";
}


##############################
# make array from file
##############################
sub file2array {
    my $self = shift;
    my ($path) = @_;

    open(my $fh_in, '<', "$path") or die "$!:$path";
    my @lines = <$fh_in>;
    close($fh_in) or die "$!:$path";

    @lines = map { $_ =~ s/\r//; $_ =~ s/\n//; $_ } @lines;

    return \@lines;
}


##############################
# save array to file
##############################
sub array2file {
    my $self = shift;
    my ($path, $ref_array) = @_;

    my @lines = @{$ref_array};

    @lines = map { $_ . "\n" } @lines;

    open(my $fh_out, '>', "$path") or die "$!:$path";
    print $fh_out @lines;
    close($fh_out) or die "$!:$path";
}


##############################
# make hash from file
##############################
sub file2hash {
    my $self = shift;
    my ($path, $delimiter) = @_;

    open(my $fh_in, '<', "$path") or die "$!:$path";
    my @lines = <$fh_in>;
    close($fh_in) or die "$!:$path";

    @lines = map { $_ =~ s/\r//; $_ =~ s/\n//; $_ } @lines;

    my %hash = ();

    foreach my $line (@lines) {
        my ($key, $value) = split(/$delimiter/, $line, 2);
        $hash{"$key"} = $value;
    }

    return \%hash;
}


##############################
# save hash to file
##############################
sub hash2file {
    my $self = shift;
    my ($path, $delimiter, $ref_hash) = @_;

    my %hash = %{$ref_hash};

    my @lines = ();

    foreach my $key ( sort keys %hash ) {
        push(@lines, $key . $delimiter . $hash{"$key"} . "\n");
    }

    open(my $fh_out, '>', "$path") or die "$!:$path";
    print $fh_out @lines;
    close($fh_out) or die "$!:$path";
}


1;

