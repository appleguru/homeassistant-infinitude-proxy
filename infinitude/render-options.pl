#!/usr/bin/perl
# Renders /infinitude/infinitude.json from the add-on's options.json.
#
# The upstream image is Alpine with apk purged, so there is no jq and no
# package manager to install one. Perl is guaranteed present, because
# Infinitude is itself a Perl application.
#
# Prints "<port> <mode>" on stdout for the calling shell script.
use strict;
use warnings;
use JSON::PP ();

my $OPTIONS_FILE = '/data/options.json';
my $SECRET_FILE  = '/data/app_secret';
my $CONFIG_FILE  = '/infinitude/infinitude.json';

my %DEFAULTS = (
    port          => 3000,
    mode          => 'Production',
    pass_reqs     => 1020,
    app_secret    => '',
    serial_tty    => '',
    serial_socket => '',
);

my $opt = {};
if ( open my $fh, '<', $OPTIONS_FILE ) {
    local $/;
    my $raw = <$fh>;
    close $fh;
    $opt = eval { JSON::PP->new->decode($raw) } || {};
}

sub val {
    my ($key) = @_;
    my $value = $opt->{$key};
    return $DEFAULTS{$key} if !defined $value || $value eq '';
    return $value;
}

# The app secret signs session cookies. Generate once and persist, so
# sessions are not invalidated on every restart.
my $app_secret = val('app_secret');
if ( $app_secret eq '' && -s $SECRET_FILE ) {
    open my $fh, '<', $SECRET_FILE or die "cannot read $SECRET_FILE: $!";
    local $/;
    $app_secret = <$fh>;
    close $fh;
    $app_secret =~ s/\s+//g;
}
if ( $app_secret eq '' ) {
    if ( open my $urandom, '<:raw', '/dev/urandom' ) {
        read $urandom, my $bytes, 32;
        close $urandom;
        $app_secret = unpack 'H*', $bytes;
    }
    else {
        my @chars = ( 'a' .. 'f', 0 .. 9 );
        $app_secret = join '', map { $chars[ int rand @chars ] } 1 .. 64;
    }
    if ( open my $fh, '>', $SECRET_FILE ) {
        print $fh $app_secret;
        close $fh;
        chmod 0600, $SECRET_FILE;
    }
}

open my $out, '>', $CONFIG_FILE or die "cannot write $CONFIG_FILE: $!";
print $out JSON::PP->new->canonical->encode(
    {
        app_secret    => "$app_secret",
        pass_reqs     => 0 + val('pass_reqs'),
        serial_tty    => "" . val('serial_tty'),
        serial_socket => "" . val('serial_socket'),
    }
);
close $out;

my $mode = val('mode');
$mode = 'Production' unless $mode =~ /\A(?:Production|Development)\z/;

my $port = 0 + val('port');
$port = 3000 unless $port > 0 && $port < 65536;

print "$port $mode\n";
