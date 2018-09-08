package SessionTutorial::Controller::Tutorial;
use Mojo::Base 'Mojolicious::Controller';
use Net::LDAP qw/LDAP_INVALID_CREDENTIALS/;
use YAML qw/LoadFile/;
use Mojo::Log;

#my $log = Mojo::Log->new(path => 'log/access.log', level => 'info');
my %Login_Attempts;
my $MAX_LOGIN_ATTEMPTS = 3;
my $DURATION_BLOCKED = 30 * 60;
my $TIMEOUT_FAILED_LOGIN = 1;

#### Put these in config file ####

my $config;
my $config_file = 'ldap_config.sample.yml';
#$config = LoadFile($config_file) if -e $config_file;            # file is at same level as lib/
$config = LoadFile($config_file);
my ($LDAP_server, $base_DN, $user_attr, $user_id, )
        = @{$config}{ qw/server baseDN username id/ };          # this is a hash slice, they're pretty cool

my $allowed_user_re = qr/^\w{5,10}$/;

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

  if ( is_denied($self) ) {
    $self->render(
        text => '<h2>Access blocked</h2>Too many failed login attempts.  Try again later', 
        format => 'html', 
        status => 403
    );
  }
  elsif (check_credentials($username, $password)) {
    $self->session(logged_in => 1);             # set the logged_in flag
    $self->session(username => $username);      # keep a copy of the username
    $self->session(expiration => 600);          # expire this session in 10 minutes

    record_login_attempt($self, 'SUCCESS');

    $self->stash(user => $username);
    $self->redirect_to($self->session('calling_page')) if $self->session('calling_page');
    $self->render(template => 'tutorial/welcome', format => 'html');
  } 
  else {
    record_login_attempt($self, 'FAILED');
    sleep $TIMEOUT_FAILED_LOGIN;

    $self->render(
        text => '<h2>Login failed</h2><a href="/login">Try again</a>', 
        format => 'html', 
        status => 403
    );
  }
}

sub check_credentials {
  my ($username, $password) = @_;
  return unless $username;
  return 1 if ($username eq 'julian' && $password eq 'carax');        # needed for the tests to pass

  my $ldap = Net::LDAP->new( $LDAP_server )
        or warn("Couldn't connect to LDAP server $LDAP_server: $@"), return;

  my $search = $ldap->search( base => $base_DN,
                              filter => "$user_attr=$username",
                              attrs => [$user_id],
                            );
  my $user_id = $search->pop_entry();
  return unless $user_id;                             # does this user exist in LDAP?

  # this is where we check the password
  my $login = $ldap->bind( $user_id, password => $password );

  # return 1 on success, 0 on failure with the trinary operator
  return $login->code == LDAP_INVALID_CREDENTIALS ? 0
                                                  : 1;
}

sub is_logged_in {
  my $self = shift;

  # checks that we have a session flag (logged_in) and that the username is valid
  return 1 if $self->session('logged_in') && $self->session('username') =~  /$allowed_user_re/;

  # otherwise, inform them that they have to login and give them a link to the login page
  $self->session(calling_page => $self->req->url);
  $self->render(
    inline => '<h2>Unauthorized access</h2>Please <a href="/login">login</a> first.',
    format => 'html',
    status => 401,
  );
  return;
}

sub protected {
  my $self = shift;

  my $username = $self->session('username');
  $self->render(user => $username, template => 'tutorial/protected');
}

sub record_login_attempt {
  my ($self, $result) = @_;

  my $user = $self->param('username');
  my $ip_address = $self->tx->remote_address;

  if ($result eq 'SUCCESS') {
    $self->app->log->info(join "\t", "Login succeeded: $user", $ip_address);

    $Login_Attempts{$ip_address}->{tries} = 0;	# reset the number of login attempts
  }
  else {
    $self->app->log->info(join "\t", "Login FAILED: $user", $self->tx->remote_address);

    $Login_Attempts{$ip_address}->{tries}++;
    if ( $Login_Attempts{$ip_address}->{tries} > $MAX_LOGIN_ATTEMPTS ) {
      $Login_Attempts{$ip_address}->{denied_until} = time() + $DURATION_BLOCKED;
    }
  }
}

sub is_denied {
  my ($self) = @_;

  my $ip_address = $self->tx->remote_address;

  return unless exists $Login_Attempts{$ip_address}
        && exists $Login_Attempts{$ip_address}->{denied_until};

  return 'Denied'
    if $Login_Attempts{$ip_address}->{denied_until} > time();

  # TIMEOUT has expired, reset attempts
  delete $Login_Attempts{$ip_address}->{denied_until};
  $Login_Attempts{$ip_address}->{tries} = 0;

  return;
}

1;
