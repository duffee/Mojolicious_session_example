# Authenticating login credentials

Well, we can't let just _anybody_ into our secure website!
We need to check that the username and password are correct.
We also need somewhere for that login button to go.

We'll look at these 3 files
* lib/SessionTutorial.pm
* lib/SessionTutorial/Controller/Tutorial.pm
* templates/tutorial/welcome.html.ep

## lib/SessionTutorial.pm
Add
```
$r->post('/login')->name('do_login')->to('Tutorial#on_user_login');
```
* explain the named route, do_login and the controller, Tutorial, where you need on_user_login

## lib/SessionTutorial/Controller/Tutorial.pm
Add a new method called **on_user_login** to handle checking credentials
```
sub on_user_login {
  my $self = shift;

  my $username = $self->param('username');
  my $password = $self->param('password');

  if (check_credentials($username, $password)) {
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

  if ( $username eq 'julian' && $password eq 'carax' ) {
    return 1;
  }

  return undef;
}
```

The form on the Login page POSTs the username and password to /login,
so we need a route that directs the request to the on_user_login method
in the Tutorial controller.

( note that "return" isn't required, but good form for chaining methods **check this** )

The check_credentials method separates the password check from the login action.
This allows us to change the authentication method in future 
while maintaining the same login behaviour.

The quickest way of making sure you've got the right behaviour is to render to text, 
as in the failed login.  Remember to set the format to html if you want to include a link.
( _why is this not default_ )
The render used in the successful login directs the output to a template
(which is composed of controller/action _and for some reason defaulted to txt output_).

## templates/tutorial/login.html.ep
fixed the form_for line to use the named route 'do_login'

## templates/tutorial/welcome.html.ep
Added a new template as a landing page for successful logins,
which is a good place to put messages and links to the content 
that the user can access.

#### NOTES ####

*OJO!* - the on_user_login method needs you to return the rendered objects

works for render(text =>), but not render(msg) which needs a template, I think

add a landing page for successful login
	templates/tutorial/welcome.html.ep

#### END NOTES ####

# Try it out
With the server running,
click through the Login link on [localhost:3000/](http://localhost:3000/)
to get to the [Login page](http://localhost:3000/login)

# Test the app

Make sure the Authentication works correctly

I've renamed `basic.t` to `00_basic.t` and copied it to `01_login.t` to add the
new tests.  It now looks like
```
my $t = Test::Mojo->new('SessionTutorial');

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
script/session_tutorial test t/01_login.t
```
We've already seen the first test.  The second posts valid credentials to the page,
checks the return status and that we are Welcomed.  The third test posts invalid
credentials, checks that we get a 403 Authorization failed status and that
we know the login failed.

# Change the Secret Passphrase
(_move this to the next step?_)

Now that we're sending passwords across the net, it's advisable to change the Secret Passphrase
that is used in security features such as signed cookies, which we're using to keep sessions.
Add
```
$self->secrets(['El Cementerio de los Libros Olvidados']);
```
to `lib/SessionTutorial.pm`.

_latest mojolicious creates a file called **session_tutorial.conf** which has a secrets line_


# Next Step

Now that we can successfully check credentials, let's make sure that we can maintain sessions
and protect private pages from unauthorised users.  Instructions continue in [Sessions](Sessions.md).

## More information

More on forms and logins can be found on Oliver G&uuml;nther's
[Applications with Mojolicious](http://oliverguenther.de/2014/04/applications-with-mojolicious-part-three-forms-and-login/ 'Forms, Logins')
or have a look at the Mojolicious Cookbook on
[basic authentication](http://localhost:3000/perldoc/Mojolicious/Guides/Cookbook#Basic-authentication1)
