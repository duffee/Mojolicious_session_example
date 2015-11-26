# Authenticating login credentials

To keep things clean, I've started a new app called Login
so that we can play with a new set of files that don't 
conflict with the other stages.  As a result you can run 
any of the stages by just stopping the morbo server and 
starting a different startup script.

```
mojo generate app Authenticate	# I've already done this bit
cd authenticate
```
This is just the same as in [GettingStarted](Getting_Started.md)
but with a new name under the lib and script directories which
is called in the start_app and new functions.

We'll look at these 3 files
* lib/Authenticate.pm
* lib/Authenticate/Controller/Login.pm
* templates/login/welcome.html.ep

## lib/Authenticate.pm
Add
```
$r->post('/login')->name('do_login')->to('Login#on_user_login');
```
* explain the named route, do_login and the controller, Login, where you need on_user_login

## lib/Authenticate/Controller/Login.pm
Ad in the on_user_login method to handle the credentials
```
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
```
* explain that username, password have been POSTed to the controller
* note that "return" isn't required, but good form for chaining methods
* the check_credentials sub separates the password check from the login action
* quickest way of making sure you've got the right behaviour is to render to text, as in the failed login
* a better render method directs the render to a template

## templates/login/login.html.ep
fixed the form_for line to use the named route 'do_login'

## templates/login/welcome.html.ep
Added a new template as a landing page for successful logins

#### NOTES ####

OJO! - the on_user_login method needs you to return the rendered objects

works for render(text =>), but not render(msg) which needs a template, I think

add a landing page for successful login
	templates/login/welcome.html.ep

#### END NOTES ####

# Try it out
Start the server with
```
morbo script/authenticate
```
and click through the Login link on [localhost:3000/](http://localhost:3000/)
to get to the [Login page](http://localhost:3000/login)

# Test the app

Make sure the Authentication works correctly

I've renamed `basic.t` to `00_basic.t` and copied it to `01_login.t` to add the
new tests.  It now looks like
```
my $t = Test::Mojo->new('Authenticate');

$t->get_ok('/login')->status_is(200)->content_like(qr/Username/i);

# test successful login - julian carax
$t->post_ok('/login' => {Accept => '*/*'} => form => {username => 'julian', password => 'carax'})
  ->status_is(200)
  ->content_like(qr/Welcome, julian/i);

# test failed login - francisco fumero
$t->post_ok('/login' => {Accept => '*/*'} => form => {username => 'francisco', password => 'fumero'})
  ->status_is(403)
  ->content_like(qr/Login failed/i);
```
(are the Accept tests necessary?)  Then run
```
script/authenticate test t/01_login.t
```
We've already seen the first test.  The second posts valid credentials to the page,
checks the return status and that we are Welcomed.  The third test posts invalid
credentials, checks that we get a 403 Authorization failed status and that
we know the login failed.

# Next Step

Now that we can successfully check credentials, let's make sure that we can maintain sessions
and protect private pages from unauthorised users.  Instructions continue in [Sessions](Sessions.md).

## More information

More on forms and logins can be found on Oliver Günther's [Applications with Mojolicious Series]
(http://oliverguenther.de/2014/04/applications-with-mojolicious-part-three-forms-and-login/ 'Forms, Logins')
