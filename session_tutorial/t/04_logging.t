use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('SessionTutorial');

# is the secure page protected?
$t->post_ok('/login' => {Accept => '*/*'} => form => {username => 'francisco', password => 'fumero'})
  ->status_is(403);
  #->content_like(qr/Login failed/i);

# successful login
$t->post_ok('/login' => {Accept => '*/*'} => form => {username => 'julian', password => 'carax'})
  ->status_is(200);
  #->content_like(qr/Welcome, julian/i);

# pull events out of the log history - last 10 log events by default
my $history;
ok($history = $t->app->log->history, 'Get log events history');
cmp_ok(@{$history}, '<=', $t->app->log->max_history_size, 'Have we filled the history buffer');

my @info_events = map { $_->[2] } grep { $_->[1] eq 'info' } @{$history};
cmp_ok(@info_events, '==', 2, 'Should only log 2 events');
subtest 'Log Messages as expected' => sub {
	for my $event ( @info_events ) {
		my $log_message_re = qr/^Login (?:succeeded|FAILED): \w+\s+127.0.0.1/;
		like($event, $log_message_re, "Login Message");
	}
};

# Change log level
is($t->app->log->level(), 'debug', 'Default log level for development is debug' );
ok($t->app->log->level('fatal'), 'Set log level to fatal');
is($t->app->log->level(), 'fatal', 'Check log level set to fatal' );

done_testing();
