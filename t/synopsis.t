#!/usr/bin/perl

use Test::More tests => 1;
use Log::Accounting::CSV;

my $obj  = new Log::Accounting::CSV(file => 't/log.csv',
    fields=>[qw/id author path date/]);

$obj->process;
$obj->report;

ok(1);

