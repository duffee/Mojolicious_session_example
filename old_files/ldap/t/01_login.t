use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('LDAP');

$t->get_ok('/login')->status_is(200)->content_like(qr/Username/i);

# test successful login - julian carax
$t->post_ok('/login' => {Accept => '*/*'} => form => {username => 'julian', password => 'carax'})
  ->status_is(200)
  ->content_like(qr/Welcome, julian/i);

# test failed login - francisco fumero
$t->post_ok('/login' => {Accept => '*/*'} => form => {username => 'francisco', password => 'fumero'})
  ->status_is(401)
  ->content_like(qr/Login failed/i);

# test failed login - empty request
$t->post_ok('/login' => {Accept => '*/*'} => form => {username => '', password => ''})
  ->status_is(401)
  ->content_like(qr/Login failed/i);

# test failed login - junk inputs
$t->post_ok('/login' => {Accept => '*/*'} => form => {username => q{''}, password => ''})
  ->status_is(401)
  ->content_like(qr/Login failed/i);

done_testing();
