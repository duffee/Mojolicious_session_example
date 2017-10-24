package SessionTutorial;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  my $self = shift;

  # Load configuration from hash returned by "my_app.conf"
  my $config = $self->plugin('Config');

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer') if $config->{perldoc};

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('Tutorial#start');

  $r->get('/login')->to('Tutorial#login');
  $r->post('/login')->name('do_login')->to('Tutorial#on_user_login');
}

1;
