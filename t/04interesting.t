use Test::More tests => 2;

use strict;
use warnings;

use Path::Class::Iterator;

require "t/help.pl";

my $no_links = setup();

my $root = 'test';

sub debug
{
    diag(@_) if $ENV{PERL_TEST};
}

ok(
    my $walker = Path::Class::Iterator->new(
        root          => $root,
        error_handler => sub {
            my ($self, $path, $msg) = @_;

            debug $self->error;
            debug "we'll skip $path";

            return 1;
        },
        follow_symlinks => 1,
        breadth_first   => 1,
        interesting     => sub {
            my ($self, $stack) = @_;

            return [sort { $b cmp $a } @$stack];

        },
    ),
    "new object"
  );

my $count = 0;
until ($walker->done)
{
    my $f = $walker->next;

    $count++;
    if (-l $f)
    {
        debug "$f is a symlink";
    }
    elsif (-d $f)
    {
        debug "$f is a dir";
    }
    elsif (-f $f)
    {
        debug "$f is a file";
    }
    else
    {
        debug "no idea what $f is";
    }

}

ok($count > 1, "found some files");

cleanup();
