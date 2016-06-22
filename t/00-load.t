#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'StuffDB' ) || print "Bail out!\n";
}

diag( "Testing StuffDB $StuffDB::VERSION, Perl $], $^X" );
