use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('HTTPS');

# login
$t->post_ok('/login' => {Accept => '*/*'} => form => {username => 'francisco', password => 'fumero'})
  ->status_is(401);

# access a protected page
$t->get_ok('/secure/protected')->status_is(401);
$t->get_ok('/secure/admin')->status_is(401);

# why doesn't this work like I think it should?
#$t->get_ok('/secure/private_page.html')->status_is(401);

# make sure we can get public pages
$t->get_ok('/index.html')->status_is(200);

done_testing();
