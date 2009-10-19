use strict;
use warnings;

use Test::More tests => 3;

use Email::MIME::Kit;

my $kit = Email::MIME::Kit->new({
  source => 't/kits/test.mkit',
});

my $email_1 = $kit->assemble({
  name => 'Reticulo Johnson',
  game => "eatin' pancakes",
});

like(
  $email_1->body,
  qr{\QReticulo Johnson is my name, eatin' pancakes is my game},
  "template stuff happened",
);

my $email_2 = $kit->assemble({
  name => 'Bryan Allen',
  game => "nukin' jar cheese",
});

like(
  $email_2->body,
  qr{\QBryan Allen is my name, nukin' jar cheese is my game},
  "template stuff happened",
);

my $fail_kit = Email::MIME::Kit->new({
  source => 't/kits/fail.mkit',
});

my $email_fail;
my $lived = eval { $fail_kit->assemble({ game => 'failing' }); 1 };

ok(! $lived, "we die if the template can't be assembled");

