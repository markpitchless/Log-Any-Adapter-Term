#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Log::Any::Adapter::Term' );
}

diag( "Testing Log::Any::Adapter::Term $Log::Any::Adapter::Term::VERSION, Perl $], $^X" );
