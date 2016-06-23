use strict;
use warnings;
use Test::More;
use Test::MockModule;
use Data::Dumper;
use File::Slurp;
use JSON::XS;
use YAML::XS;

BEGIN { use_ok('StuffDB') or BAIL_OUT('cannot use StuffDB') }

done_testing();
