package Sessions;
use Mojo::Base 'Mojolicious';
#use Mojolicious::Static;

# This method will run once at server start
sub startup {
  my $self = shift;

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer');

  # set secret passphrase
  $self->secrets(['El Cementerio de los Libros Olvidados']);

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('login#start');

  $r->get('/login')->to('login#login');
  $r->post('/login')->name('do_login')->to('Login#on_user_login');

  # some protected pages
  my $authorized = $r->under('/secure')->to('Secure#is_logged_in');
  $authorized->get('/protected')->to('Secure#protected');
  $authorized->get('/admin')->to(template => 'secure/admin');
  #$authorized->get('/private_page')->reply->static('private_page.html');
}

1;
