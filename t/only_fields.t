#!/usr/bin/perl

use Test::More tests => 2;
use Log::Accounting::CSV;

my $obj  = new Log::Accounting::CSV(
    file => 't/log.first.line.are.fields.csv',
    first_line_are_fields => 1,
    only_fields => [qw/author filename/]
    );

$obj->process;

is($obj->result('author')->{alice},2);
is($obj->result('filename')->{'/foo.txt'},4);

