#!/usr/bin/perl

use strict;
use warnings;
use Log::Any qw($log);
use Log::Any::Adapter;
Log::Any::Adapter->set( 'Term', level => 'info' );

$log->info("Hello");
$log->notice("Lots happening");
$log->warning("Looking dodgey");
$log->error("Bang!");
