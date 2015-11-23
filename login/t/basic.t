use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('Login');
$t->get_ok('/')->status_is(200)->content_like(qr/Mojolicious/i);

$t->get_ok('/login')->status_is(200)->content_like(qr/Username/i);

done_testing();
