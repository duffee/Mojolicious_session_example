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
    $self->render(user => $username, 
				template => 'tutorial/welcome', 
				format => 'html'
			);
  } 
  else {
    $self->render(text => '<h2>Login failed</h2><a href="/login">Try again</a>', 
				format => 'html', 
				status => 403
			);
  }
}

sub check_credentials {
  my ($username, $password) = @_;

  my %password_for = ( daniel => 'sempere',
				julian => 'carax',
				nuria => 'monfort',
  );

  return ( exists $password_for{$username} && $password_for{$username} eq $password );
}

1;
