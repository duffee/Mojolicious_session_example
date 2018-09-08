use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('SessionTutorial');

$t->post_ok('/login' => {Accept => '*/*'} => form => {username => 'julian', password => 'carax'})
  ->status_is(200)
  #->element_exists('form input[name="username"]');
  ->content_like(qr/Julian/);

$t->get_ok('/secure/protected')
  ->content_like(qr/Logout/)
  ->element_exists('div.top-menu');

done_testing();
