package Log::Accounting::CSV;
use strict;
use warnings;
use Text::CSV_XS;
use IO::All;
use Spiffy '-Base';
use Algorithm::Accounting;
our $VERSION = '0.01';
use YAML;

field 'file';
field 'fields';

field '_algo';

sub process {
  $self->file   || die("Can't process without input file");
  $self->fields || die("Can't process without knowing number of fields");
  my $fields = $self->fields;
  my $algo = Algorithm::Accounting->new(fields => [1..$fields]);

  my $csv = Text::CSV_XS->new();
  for(io($self->file)->chomp->slurp) {
    next unless $_; # Ignore empty lines
    my $status = $csv->parse($_);
    my @columns = $csv->fields();
    $algo->append_data([\@columns]);
  } 
  $self->_algo($algo);
}

sub report {
  my $algo = $self->_algo || die("Can't report without algo obj");
  $algo->report;
}

sub result {
  my $algo = $self->_algo || die("Can't return result without algo obj");
  $algo->result(@_);
}

1;

__END__

=head1 NAME

  Log::Accounting::CSV - Accounting CSV format Data

=head1 SYNOPSIS

  my $acc = Log::Accounting::CSV->new(file => 'log.csv', fields => 4);
  $acc->process;
  $acc->report;

=head1 DESCRIPTION

This module make the use of L<Algorithm::Accounting>, and generate
accounting information from general CSV files. It parse CSV file,
and feed rows into an L<Algorithm::Accounting> object, and provides
result() wrapper which return the result. 

=head1 COPYRIGHT

Copyright 2004 by Kang-min Liu <gugod@gugod.org>.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

See <http://www.perl.com/perl/misc/Artistic.html>

=cut

