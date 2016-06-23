use strict;
use warnings;
use Test::More;
use Test::MockModule;
use Data::Dumper;
use File::Slurp;
use JSON::XS;
use YAML::XS;

BEGIN { use_ok('StuffDB') or BAIL_OUT('cannot use StuffDB') }

subtest 'json' => sub {
    my $stuffdb = 'StuffDB';
    my $method  = '_read_config_from_file';
    my $config  = {
        schemas => [ 'foo', 'bar' ],
        scripts => ['do_something.sh'],
    };

    my $mock_module = Test::MockModule->new('StuffDB');
    $mock_module->mock( '_find_config_file', sub { return 'stuffdb.json' } );

    #write json config File
    write_file( 'stuffdb.json', encode_json($config) );

    my %config = $stuffdb->$method();
    is_deeply( \%config, $config, 'read config from default json file' );

    #remove created config file and other cleanup
    unlink('stuffdb.json');
    $mock_module->unmock_all();
};
subtest 'prefer_input_config' => sub {
    my $stuffdb = 'StuffDB';
    my $method  = '_read_config_from_file';

    my $mock_module = Test::MockModule->new($stuffdb);
    $mock_module->mock( '_find_config_file', sub { return 'stuffdb.json' } );

    my $config = {
        schemas => [ 'foo', 'bar' ],
        scripts => ['do_something.sh'],
    };

    #write json config File
    write_file( 'stuffdb.json', encode_json($config) );

    my %prev_config = ( schemas => ['foo'] );
    my %config = $stuffdb->$method(%prev_config);

    is_deeply(
        \%config,
        { schemas => ['foo'], scripts => ['do_something.sh'] },
        'input config overrides config from file'
    );

    #remove created config file
    unlink('stuffdb.json');
    $mock_module->unmock_all();
};

done_testing();
