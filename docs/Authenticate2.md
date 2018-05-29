# Authentication - A Slight Return

You've got a login page to stop the great unwashed from getting into your website,
but what about the Bad Person who tries to crack your passwords with a script?

Standard proceedure is to `sleep` on failure which doesn't bother a human,
but slows down a brute force attack.
The second step is to block access after a number of failed attempts,
usually for a timeout period so that a real person can eventually get back
into your system without needing an administrator everytime.

## lib/SessionTutorial/Controller/Tutorial.pm
Add two new methods, **record_login_attempts** and **is_denied**
and plug them into the **on_user_login** method.

```
sub record_login_attempt {
  my ($self, $result) = @_;

  my $user = $self->params('username');
  my $ip_address = $self->tx->remote_address;

  if ($result eq 'SUCCESS') {
    $log->info(join "\t", "Login succeeded: $user", $ip_address);
    $Login_Attempts{$ip_address}->{tries} = 0;  # reset the number of login attempts
  }
  else {
    $log->info(join "\t", "Login FAILED: $user", $self->tx->remote_address);

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
```
Check to see if the authentication attempt should be blocked before
checking credentials
```
  if ( is_denied($self) ) {
    $self->render(
        text => '<h2>Access blocked</h2>Too many failed login attempts.  Try again later',
        format => 'html',
        status => 403
    );
  }
  elsif (check_credentials($username, $password)) {
```
and change the logging calls from
	$log->info(join "\t", "Login succeeded ... etc, etc
to
	record_login_attempt($self, 'SUCCESS');
passing in the `$self` object for easy access to the context.
_may not be the best way to access the username parameter and caller ip address_


## Where do we render the Login Blocked page?
I've just added a text render in the **on_user_login** method.
_Is that good enough?_

## Storing login attempts

I've gone for a simple hash just to illustrate the principle.
Are you worried about memory consumption?
How about `tie`ing the %Login_Attempts hash to a file stored on disk?
Perhaps you want to store a lot more information about logins,
say to ask the user if they recognize their last successful login?
It might be better to use a database (Mysql, Redis, Sqlite) to store 
the attempts and allow the administrator to access or reset the data.
Only limited by your imagination.

# Try it out
With the server running,
click through the Login link on [localhost:3000/](http://localhost:3000/)
to get to the [Login page](http://localhost:3000/login)
and then login with the wrong password 3 times.
You should then see the **Access Denied** page when you try to login again.

#### TODO ####

# Test the app

```
script/session_tutorial test t/01_login.t
```

# Next Step

**This tutorial finishes here.**

Instructions continue in [Authenticate2](Authenticate2.md).

## More information

Some random links:
* [Authentication Cheat Sheet](https://www.owasp.org/index.php/Authentication_Cheat_Sheet)
from the
[Open Web Application Security Project](https://www.owasp.org/index.php/Main_Page)
* https://itworksonmymachine.wordpress.com/2008/07/17/forms-authentication-timeout-vs-session-timeout/
