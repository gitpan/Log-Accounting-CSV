#!/usr/bin/perl

use Test::More tests => 1;
use Log::Accounting::CSV;

my $obj  = new Log::Accounting::CSV(
    file => 't/log.first.line.are.fields.csv',
    first_line_are_fields => 1);

$obj->process;

is($obj->result->[0]->{1},1);

