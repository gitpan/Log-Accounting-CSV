use inc::Module::Install;

name            ('Log-Accounting-CSV');
abstract        ('Accounting CSV format Data');
author          ('Kang-min Liu <gugod@gugod.org>');
license         ('perl');
version_from    ('lib/Log/Accounting/CSV.pm');
requires        ('Spiffy');
requires        ('Text::CSV_XS');
requires        ('Algorithm::Accounting');
build_requires  ('Test::More');

&WriteAll;

