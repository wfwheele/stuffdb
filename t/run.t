use strict;
use warnings;
use Test::MockModule;
use Test::More;
use Test::Exception;
use StuffDB;
use File::Slurp;
use JSON::XS qw/encode_json/;

my $module = 'StuffDB';
my $method = 'run';

my $mock_dbi = Test::MockModule->new('DBI');

{

    package Mock::dbh;

    sub new {
        my $self = bless { return_value => 1 };
        return $self;
    }

    sub return_vlue {
        my $self = shift;

        if (@_) {
            $self->{return_value} = shift;
            return;
        }
        return $self->{return_value};
    }

    sub do {
        my $self = shift;
        return $self->{return_value};
    }

    sub commit {
        my $self = shift;
        return $self->{return_value};
    }
}

$mock_dbi->mock(
    connect_cached => sub {
        return Mock::dbh->new();
    }
);

write_file(
    'stuffdb.json',
    encode_json(
        {   schemas => [ 'foo', 'bar' ],
            commands => [ [ 'echo', 'woo' ], [ 'echo', 'foo' ] ]
        }
    )
);

lives_ok { $module->$method(); } 'expected to live';

done_testing;
