package Sessions::Controller::Login;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub start {
  my $self = shift;

  # Render template "login/start.html.ep" with message
  $self->render(msg => 'Creating a Login Page');
}

sub login {
  my $self = shift;

  # Render template "login/login.html.ep" with message
  $self->render(msg => 'Login required');
}

sub check_credentials {
	my ($username, $password) = @_;

	my %password_for = ( daniel => 'sempere',
					julian => 'carax',
					nuria => 'monfort',
		);

	return ( exists $password_for{$username} && $password_for{$username} eq $password );
}

sub on_user_login {
  my $self = shift;

  my $username = $self->param('username');
  my $password = $self->param('password');

  if (check_credentials($username, $password)) {
	$self->session(logged_in => 1);				# set the logged_in flag
	$self->session(username => $username);		# keep a copy of the username
	$self->session(expiration => 600);			# expire this session in 10 minutes

	return $self->render(user => $username, template => 'login/welcome');
  }
  else {
    return $self->render(text => '<h2>Login failed</h2><a href="/login">Try again</a>', status => 403);
  }
}
	

1;
