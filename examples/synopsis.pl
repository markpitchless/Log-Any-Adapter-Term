#!/usr/bin/perl

use strict;
use warnings;
use Log::Any qw($log);
use Log::Any::Adapter;
Log::Any::Adapter->set( 'Term', level => 'debug' );

$log->debug("Hello world");
$log->info("Starting");
$log->notice("Lots happening");
$log->warning("Looking dodgey");
$log->error("Bang!");
$log->critical("Out of widgets");
$log->alert("Please send help");
$log->emergency("Their dead Dave");
