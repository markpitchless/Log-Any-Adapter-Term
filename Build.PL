use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Log::Any::Adapter::Term',
    license             => 'perl',
    dist_author         => q{Mark Pitchless <markpitchless@gmail.com>},
    dist_version_from   => 'lib/Log/Any/Adapter/Term.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'Log-Any-Adapter-Term-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
