package SessionTutorial::Controller::Tutorial;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub start {
  my $self = shift;

  # Render template "tutorial/start.html.ep" with message
  $self->render(msg => 'Creating a Login Page');
}

sub login {
  my $self = shift;

  # Render template "tutorial/login.html.ep" with message
  $self->render(msg => 'Login required');
}

sub on_user_login {
  my $self = shift;

  my $username = $self->param('username');
  my $password = $self->param('password');

  if (check_credentials($username, $password)) {
    return $self->render(user => $username, template => 'login/welcome');
  } 
  else {
    return $self->render(text => '<h2>Login failed</h2><a href="/login">Try again</a>', status => 403);
  }
}

sub check_credentials {
  my ($username, $password) = @_;

  if ( $username eq 'julian' && $password eq 'carax' ) {
    return 1;
  }

  return undef;
}

1;
