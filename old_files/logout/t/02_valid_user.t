use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('Logout');

# login
$t->post_ok('/login' => {Accept => '*/*'} => form => {username => 'julian', password => 'carax'})
  ->status_is(200);

# access a protected page
$t->get_ok('/secure/protected')->status_is(200);
$t->get_ok('/secure/admin')->status_is(200);

done_testing();
