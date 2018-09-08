use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('SessionTutorial');

ok( $t->app->renderer->helpers->{"oauth2.providers"}, 'providers' );

done_testing();
