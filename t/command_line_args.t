use strict;
use warnings;
use Test::More;
use Test::Exception;
use StuffDB;

my $module = 'StuffDB';
my $method = '_process_command_line';

@ARGV = ();
my %got = $module->$method();
is_deeply( \%got, {}, 'no args returns empty hash' );

@ARGV = (
    "--config",   "foobar", "--schemas",  "foo",
    "--schemas",  "bar",    "--commands", 'echo stuff',
    "--commands", 'echo foo',
);

%got = $module->$method();
is_deeply(
    \%got,
    {   config   => 'foobar',
        schemas  => [ 'foo', 'bar' ],
        commands => [ [ 'echo', 'stuff' ], [ 'echo', 'foo' ] ]
    }
);

done_testing();
