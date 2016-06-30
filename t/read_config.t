use strict;
use warnings;
use Test::More;
use Test::MockModule;
use Test::Exception;
use File::Slurp;
use JSON::XS;
use YAML::XS;

BEGIN { use_ok('StuffDB') or BAIL_OUT('cannot use StuffDB') }

my $module = 'StuffDB';

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

    %config = $stuffdb->$method( config => 'stuffdb.json' );
    $config->{config} = 'stuffdb.json';
    is_deeply( \%config, $config, 'read config from specified json file' );

    #remove created config file and other cleanup
    unlink('stuffdb.json');
    $mock_module->unmock_all();
};

subtest 'yaml' => sub {
    my $stuffdb = 'StuffDB';
    my $method  = '_read_config_from_file';

    my $mock_module = Test::MockModule->new($stuffdb);
    $mock_module->mock( '_find_config_file', sub { return 'stuffdb.yaml' } );

    my $config = {
        schemas => [ 'foo', 'bar' ],
        scripts => ['do_something.sh'],
    };

    write_file( 'stuffdb.yaml', Dump($config) );
    my %config = $stuffdb->$method();
    is_deeply(
        \%config,
        {   schemas => [ 'foo', 'bar' ],
            scripts => ['do_something.sh'],
        },
        'correct reads and decode yaml config'
    );

    unlink('stuffdb.yaml');

    $mock_module->mock( '_find_config_file', sub { return 'stuffdb.yml' } );

    write_file( 'stuffdb.yml', Dump($config) );

    %config = $stuffdb->$method();
    is_deeply(
        \%config,
        {   schemas => [ 'foo', 'bar' ],
            scripts => ['do_something.sh'],
        },
        'correct reads and decode yml config'
    );

    unlink('stuffdb.yml');
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

subtest '_find_config_file' => sub {
    my $stuffdb = 'StuffDB';
    my $method  = '_find_config_file';

    for my $expected_file (qw/stuffdb.json stuffdb.yaml stuffdb.yml/) {

        touch($expected_file);

        my $conf_file = $stuffdb->$method();
        is( $conf_file, $expected_file, "found $expected_file" );

        unlink($expected_file);

    }

    my $file = $stuffdb->$method();
    ok( !$file, 'falsey value return when no file found' );

    for my $other_file (qw/other.json other.yaml other.yml/) {
        touch($other_file);

        $file = $stuffdb->$method();
        ok( !$file, 'does not find json or yaml files not named stuffdb' );

        unlink($other_file);
    }

};

subtest 'fail_cases' => sub {
    throws_ok { $module->_read_config_from_file(); }
    qr/no config file specified or found/,
        'Fails when no config found or specified';
};

done_testing();

sub touch {
    my $filename = shift;

    open( my $fh, '>', $filename ) or die "Could not open file '$filename' $!";
    close $fh;
    return;
}
