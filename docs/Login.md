# Making a Login page

To keep things clean, I've started a new app called Login
so that we can play with a new set of files that don't 
conflict with the other stages.  As a result you can run 
any of the stages by just stopping the morbo server and 
starting a different startup script.

```
mojo generate app Login
cd login
```
This is just the same as in [GettingStarted](Getting_Started.md)
but with a new name under the lib and script directories which
is called in the start_app and new functions.

We'll look at these 4 files
* script/login
* lib/Login.pm
* lib/Login/Controller/Login.pm
* templates/login/start.html.ep

## script/login

The startup script uses the line `Mojolicious::Commands->start_app('Login')` to tell
Mojolicious to look in the `lib` directory for `Login.pm`.  When we generate
the app, it knows where it looks.  No changes necessary here.

## lib/Login.pm

Straight out of the box, it looks like this.
Like any module, it starts with the package line.  
```
package Login;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  my $self = shift;

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer');

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('example#welcome');
}

1;
```
change `$r->get('/')->to('example#welcome');`
to `$r->get('/')->to('login#start');` and add a new route
`$r->get('/login')->to('login#login');`

The route to the controller has two parts.  The `login` looks for `lib/Login/Controller/Login.pm` 
and the `start` runs the `start` action (sub) in the controller file.

## lib/Login/Controller/Login.pm
Rename `lib/Login/Controller/Example.pm` to `lib/Login/Controller/Login.pm`,
change the package name, rename the welcome method to start and change the message
to end up like this


```
package Login::Controller::Login;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub start {
  my $self = shift;

  # Render template "login/start.html.ep" with message
  $self->render(msg => 'Creating a Login Page');
}

1;
```

## templates/login/start.html.ep

This is the default destination for your route's action that we set in
`lib/Login.pm`.  You can either rename `welcome.html.ep` 

```
% layout 'default';
% title 'Login example - Page 1';
<h2><%= $msg %></h2>
This is the starting page for the first step of the Session Example
```

# Try it out
Start the server with
```
morbo script/login
```
and have a look at your new Start page on [localhost:3000/](http://localhost:3000/)

## add a new route
Let's add a Login page.  Start with putting in a link to it on the Start
page `templates/login/start.html.ep` at the bottom.
```
<p>
This is a link to the
%= link_to Login => 'login'
page (which we should put into a navigational menu later)
``` 

Add a route in `lib/Login/Controller/Login.pm` for `login`
```
sub login {
  my $self = shift;

  # Render template "login/login.html.ep" with message
  $self->render(msg => 'Login required');
}
```
and a new template `templates/login/login.html.ep` with a skeleton form
```
% layout 'default';
% title 'Login example - Page 2';
<h2><%= $msg %></h2>
This is the login page for the first step of the Session Example.
<p>
%= form_for login => {format => 'txt'} => (method => 'POST') => begin
  %= text_field 'username'
  %= submit_button
% end
```
That's a rubbish login page.  Add this to the form to add a password field
and label everything just for the bare minimum.
```
%= form_for login => {format => 'txt'} => (method => 'POST') => begin
  Username: 
  %= text_field 'username'
  <br>
  Password:
  %= password_field 'password'
  <br>
  %= submit_button 'Login'
% end
```
Hopefully your password is starred out.

# Test the app

Make sure the Login page is rendered correctly.

Add `$t->get_ok('/login')->status_is(200)->content_like(qr/Username/i);`
to `t/basic.t` and run
```
script/login test t/basic.t		# this doesn't work on my machine - why?
```

# Next Step

Clicking on the Login button takes you to a page that doesn't exist
yet where we will need to check the user's credentials
using the instructions in [Authenticate](Authenticate.md)

## More information

More on rendering and validating forms can be found on 
[localhost:3000/perldoc/Mojolicious/Guides/Rendering]
(http://localhost:3000/perldoc/Mojolicious/Guides/Rendering 'Mojolicious::Guides::Rendering')
