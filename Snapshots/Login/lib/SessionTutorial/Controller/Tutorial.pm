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

1;
