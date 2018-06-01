use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('SessionTutorial');

# is the secure page protected?
$t->post_ok('/login' => {Accept => '*/*'} => form => {username => 'francisco', password => 'fumero'})
  ->status_is(403)
  ->content_like(qr/Login failed/i);

$t->get_ok('/secure/protected')->status_is(401, 'Protected page is inaccessible without correct login');

$t->get_ok('/login')->status_is(200)->content_like(qr/Username/i);

# successful login
$t->post_ok('/login' => {Accept => '*/*'} => form => {username => 'julian', password => 'carax'})
  ->status_is(302, 'Redirected to Welcome page')
  ->content_like(qr/Welcome, julian/i);

# check that the logout works as intended
$t->get_ok('/secure/protected')->status_is(200);
$t->get_ok('/logout')->status_is(302, 'Redirected to Login page');
$t->get_ok('/secure/protected')->status_is(401, 'Logout removes access to protected page');

done_testing();
