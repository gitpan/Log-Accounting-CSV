#!/usr/bin/perl

use Test::More tests => 1;
use Log::Accounting::CSV;

my $obj  = new Log::Accounting::CSV(file => 't/log.csv',fields=>4);

$obj->process;
$obj->report;

ok(1);

