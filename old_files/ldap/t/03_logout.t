use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('LDAP');

# login
$t->post_ok('/login' => {Accept => '*/*'} => form => {username => 'julian', password => 'carax'})
  ->status_is(200);

# access a protected page
$t->get_ok('/secure/protected')->status_is(200);
$t->get_ok('/secure/admin')->status_is(200);

# logout, http status 302 is because the logout redirects us to '/'
$t->get_ok('/logout')->status_is(302);

# should now deny access to protected pages
$t->get_ok('/secure/protected')->status_is(401);
$t->get_ok('/secure/admin')->status_is(401);

done_testing();
