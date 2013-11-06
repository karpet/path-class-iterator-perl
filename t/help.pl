# common testing functions

use Path::Class;

my %links = (
    'cannot_chdir' => file( 'test', 'link_to_cannot_chdir' )->stringify,
    'foo'          => file( 'test', 'bar' )->stringify,
    'nosuchdir'    => file( 'test', 'no_such_dir' )->stringify
);
my $dir = dir(qw( test cannot_chdir ));

sub setup {
    mkdir( "$dir", 0000 );

    my $supports_symlink = eval { symlink( "", "" ); 1 };

    if ( !$supports_symlink ) { return 0 }

    for my $real ( keys %links ) {
        symlink $real, $links{$real}
            or warn "Can't symlink $links{$real} -> $real";
    }

    return 1;
}

sub cleanup {
    for my $r ( keys %links ) {
        if ( -l $links{$r} ) {
            my $l = $links{$r};
            unlink($l) or warn "can't unlink $l";
        }
    }
    chmod 0777, "$dir";
    rmdir "$dir";
}

1;
