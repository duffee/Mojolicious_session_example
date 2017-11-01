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
    $self->session(logged_in => 1);             # set the logged_in flag
    $self->session(username => $username);      # keep a copy of the username
    $self->session(expiration => 600);          # expire this session in 10 minutes

    $self->stash(user => $username);
    $self->render(template => 'tutorial/welcome', format => 'html');
  } 
  else {
    $self->render(
        text => '<h2>Login failed</h2><a href="/login">Try again</a>', 
        format => 'html', 
        status => 403
    );
  }
}

sub check_credentials {
  my ($username, $password) = @_;

  my %password_for = ( daniel => 'sempere',
			julian => 'carax',
			nuria  => 'monfort',
  );

  return ( exists $password_for{$username} && $password_for{$username} eq $password );
}

sub is_logged_in {
  my $self = shift;

  # checks that we have a session flag (logged_in) and that the username is valid
  return 1 if $self->session('logged_in') && $self->session('username') =~  /^(daniel|julian|nuria)$/;

  # otherwise, inform them that they have to login and give them a link to the login page
  $self->render(
    inline => '<h2>Unauthorized access</h2>Please <a href="/login">login</a> first.',
    format => 'html',
    status => 401,
  );
  return undef;
}

1;
