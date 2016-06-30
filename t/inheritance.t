package MojoPgTest;
use Mojo::Base 'Mojo::Pg';
has db_class => 'MojoPgTestDatabase';

package MojoPgTestDatabase;
use Mojo::Base 'Mojo::Pg::Database';
has result_class => 'MojoPgTestResults';

package MojoPgTestResults;
use Mojo::Base 'Mojo::Pg::Results';

package test;

use Mojo::Base -strict;
use Test::More;

plan skip_all => 'set TEST_ONLINE to enable this test' unless $ENV{TEST_ONLINE};

my $pg_class='MojoPgTest';
my $db_class = 'MojoPgTestDatabase';
my $result_class = 'MojoPgTestResults';

# Connected
my $pg = MojoPgTest->new($ENV{TEST_ONLINE});
ok $pg->db->ping, 'connected';
isa_ok $pg, $pg_class, 'top class';

my $db = $pg->db;
isa_ok $db, $db_class, 'database class';

my $result;
my $cb = sub {
  my ($db, $err, $res) = @_;
  die $err if $err;
  $result = $res;
};
$db->query('select 1', $cb);
Mojo::IOLoop->start unless Mojo::IOLoop->is_running;
isa_ok $result, $result_class, 'result class';


$result = $db->query('select 1');
isa_ok $result, $result_class, 'result class';


done_testing();


