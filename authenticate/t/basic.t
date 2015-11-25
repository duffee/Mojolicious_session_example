use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('Authenticate');
$t->get_ok('/')->status_is(200)->content_like(qr/Login/i);

$t->get_ok('/login')->status_is(200)->content_like(qr/Username/i);

#### TODO
# test successful login - julian carax
#
# test failed login - francisco fumero

done_testing();
