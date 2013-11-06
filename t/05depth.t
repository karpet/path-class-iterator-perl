#!/usr/bin/env perl

use strict;
use Test::More;
use Path::Class::Iterator;

require "t/help.pl";

my $symlinks_supported = setup();

diag( "symlinks_supported=" . $symlinks_supported );

if ( !$symlinks_supported ) {
    plan tests => 12;    # 14 - 2 skipped
}
else {
    plan tests => 14;
}

my $root    = 'test';
my $skipped = 0;

sub debug {
    diag(@_) if $ENV{PERL_TEST};
}

ok( my $walker = Path::Class::Iterator->new(
        root          => $root,
        error_handler => sub {
            my ( $self, $path, $msg ) = @_;

            debug $self->error;
            debug "we'll skip $path";
            $skipped++;

            return 1;
        },
        follow_symlinks => 1,
        breadth_first   => 1
    ),
    "new object"
);

my $count = 0;
until ( $walker->done ) {
    my $f = $walker->next;
    my $d = $f->depth;
    is( $d, $f->depth, "depth of $f == $d" );
    $count++;
}

diag(`ls -l $root`);
if ( !$symlinks_supported ) {
    is( $count,   9, "found $count files" );
    is( $skipped, 0, "skipped $skipped files" );
}
else {
    is( $count,   11, "found $count files" );
    is( $skipped, 2,  "skipped $skipped files" );
}

cleanup();

