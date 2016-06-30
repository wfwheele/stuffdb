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
    "--config",     "foobar", "--schemas",    "foo",
    "--schemas",    "bar",    "--setup_cmds", 'echo stuff',
    "--setup_cmds", 'echo foo',
);

%got = $module->$method();
is_deeply(
    \%got,
    {   config     => 'foobar',
        schemas    => [ 'foo', 'bar' ],
        setup_cmds => [ [ 'echo', 'stuff' ], [ 'echo', 'foo' ] ]
    }
);

done_testing();
