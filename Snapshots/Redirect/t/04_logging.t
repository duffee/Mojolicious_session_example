use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('SessionTutorial');

# is the secure page protected?
$t->post_ok('/login' => {Accept => '*/*'} => form => {username => 'francisco', password => 'fumero'})
  ->status_is(403)
  ->content_like(qr/Login failed/i);

# successful login
$t->post_ok('/login' => {Accept => '*/*'} => form => {username => 'julian', password => 'carax'})
  ->status_is(200)
  ->content_like(qr/Welcome, julian/i);

diag('TODO - How do we test Logging?');
diag('TODO - Does the test write to the log and do we want to turn it off in all the other tests?');
# Change log level
#$t->app->log->level('fatal');

done_testing();
