package Sessions::Controller::Secure;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub protected {
  my $self = shift;

  return unless $self->session('logged_in');	# I expected the under method to handle this, but I have to do it in the method too?!?

  my $username = $self->session('username');
  $self->render(user => $username, template => 'secure/protected');
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
    return $self->render(text => '<h2>Login failed</h2><a href="/login">Try again</a>', status => 401);
  }
}
	
sub is_logged_in {
	my $self = shift;

 	return 1 if $self->session('logged_in');

	$self->render(
		inline => '<h2>Unauthorized access</h2>Please <a href="/login">login</a> first.',
		status => 401
	);
}

1;
