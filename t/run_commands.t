use strict;
use warnings;
use Test::More;
use Test::Exception;
use StuffDB;

my $module = 'StuffDB';
my $method = 'run_commands';

my $commands_ref = [ [ 'echo', 'cmd1' ], [ 'echo', 'cmd2' ] ];

lives_ok { $module->$method($commands_ref) } 'call commands lived';

throws_ok { $module->$method( [ [ 'foo', 'bar' ] ] ) } qr/Failed to run/,
    'unknown command caught';

throws_ok { $module->$method( [ ['touch'] ] ) } qr/Failed to run/,
    'other errors caught';
done_testing();
