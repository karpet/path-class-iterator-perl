use strict;
use warnings;
use inc::Module::Install;
use 5.008003;

name 'Path-Class-Iterator';
all_from 'lib/Path/Class/Iterator.pm';

# runtime dependencies
requires 'Test::More'            => 0;
requires 'Data::Dump'            => 0;
requires 'Iterator'              => 0;
requires 'Path::Class'           => 0;
requires 'Class::Accessor::Fast' => 0;
requires 'IO::Dir'               => 0;

perl_version '5.8.3';
license 'http://dev.perl.org/licenses/';
homepage 'https://github.com/karpet/path-class-iterator-perl';
bugtracker 'http://rt.cpan.org/NoAuth/Bugs.html?Dist=Path-Class-Iterator';
repository 'http://github.com/karpet/path-class-iterator-perl';

WriteMakefile(
    clean => {
        FILES =>
            'test/cannot_chdir test/link_to_cannot_chdir test/bar test/no_such_dir'
    }
);
