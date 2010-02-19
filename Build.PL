use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Log::Any::Adapter::Term',
    license             => 'perl',
    dist_author         => q{Mark Pitchless <markpitchless@gmail.com>},
    dist_version_from   => 'lib/Log/Any/Adapter/Term.pm',
    requires => {
        'Log::Any'          => 0.06,
        'Log::Any::Adapter' => 0.02,
        'Term::ANSIColor'   => 0,
    },
    build_requires => {
        'Test::More'   => 0,
        'Test::Output' => 0.16,
    },
    add_to_cleanup     => [ 'Log-Any-Adapter-Term-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
