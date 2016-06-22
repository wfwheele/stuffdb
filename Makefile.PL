use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME               => 'StuffDB',
    AUTHOR             => q{William Frank Wheeler II <wfwheele@buffalo.edu>},
    VERSION_FROM       => 'lib/StuffDB.pm',
    ABSTRACT_FROM      => 'lib/StuffDB.pm',
    LICENSE            => 'artistic_2',
    PL_FILES           => {},
    MIN_PERL_VERSION   => 5.006,
    CONFIGURE_REQUIRES => { 'ExtUtils::MakeMaker' => 0, },
    BUILD_REQUIRES     => { 'Test::More' => 0, },
    PREREQ_PM          => {

        #'ABC'              => 1.6,
        #'Foo::Bar::Module' => 5.0401,
        'DBI'         => 1.6,
        'DBD::Oracle' => 1.7,
        'JSON::XS'    => 3.02,
        'YAML::XS'    => 0.62,
        'File::Slurp' => 9999.0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'StuffDB-*' },
);
