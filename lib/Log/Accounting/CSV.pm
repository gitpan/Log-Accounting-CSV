package Log::Accounting::CSV;
use strict;
use warnings;
use Text::CSV_XS;
use IO::All;
use Spiffy '-Base';
use Algorithm::Accounting;
our $VERSION = '0.02';

field 'file';
field 'fields';
field 'only_fields';
field 'first_line_are_fields';

field '_algo';

sub process {
  $self->file   || die("Can't process without input file");
  my $io = io($self->file)->chomp;
  my $csv = Text::CSV_XS->new();

  if($self->first_line_are_fields) {
    my $line = $io->getline;
    my $status = $csv->parse($line);
    my @columns = $csv->fields();
    $self->fields(\@columns); 
  }

  $self->fields || die("Can't process without knowing number of fields");
  my $fields = $self->fields;

  my @only_columns;
  if(my $limit = $self->only_fields) {
    for my $limt (@$limit) {
      for my $i (0..scalar(@$fields)-1) {
        push @only_columns,$i if($fields->[$i] eq $limt);
      }
    }
  } else {
    @only_columns = 0..scalar(@$fields)-1;
  }

  my $algo = Algorithm::Accounting->new(fields => ($self->only_fields || $fields));

  while(my $line = $io->getline) {
    next unless $line; # Ignore empty lines
    my $status = $csv->parse($line);
    my @data = ($csv->fields())[@only_columns];
    $algo->append_data([\@data]);
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

  my $acc = Log::Accounting::CSV->new(file => 'log.csv');
  $acc->process;
  $acc->report;

=head1 DESCRIPTION

This module make the use of L<Algorithm::Accounting>, and generate
accounting information from general CSV files. It parse CSV file,
and feed rows into an L<Algorithm::Accounting> object, and provides
result() wrapper which return the result. 

You may set a C<first_line_are_fields> flag parameter to indicate
the first line of given CSV file are actually field names. So
C<Log::Accounting::CSV> would automatically generate field names
for you. Otherwise you'll have to provide field names by yourself.

You may give an C<only_fields> parameter (arrayref) to indeicate
that you only want to generate the result for these fields.  It'll
save much memorry while the among of data is huge.

=head1 COPYRIGHT

Copyright 2004 by Kang-min Liu <gugod@gugod.org>.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

See <http://www.perl.com/perl/misc/Artistic.html>

=cut

