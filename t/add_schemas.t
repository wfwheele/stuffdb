use strict;
use warnings;
use Test::More;
use Data::Dumper;

BEGIN { use_ok('StuffDB') or BAIL_OUT('could use StuffDB'); }

SKIP: {
    skip 'only run from automated environment', 2
        unless exists $ENV{DBSTUFF_AUTO_TEST};
    for ( 1 .. 2 ) {
        my $stuffdb = 'StuffDB';
        my @test_schemas = ( 'foobar', 'barfoo' );

        $stuffdb->create_schemas( \@test_schemas );

        #check if they got there okay
        my $dbh = DBI->connect( "dbi:Oracle:host=ora_test;port=1521;sid=xe",
            "system", "oracle" );

        my $arr_ref
            = $dbh->selectall_arrayref(
            q{select username from all_users where username = 'FOOBAR' or username = 'BARFOO'}
            );
        is_deeply( $arr_ref, [ ['FOOBAR'], ['BARFOO'] ] );
    }
}

done_testing();
