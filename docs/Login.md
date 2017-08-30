# Making a Login page

Let's get started by looking at these 4 files in `session_tutorial`
* script/session_tutorial
* lib/SessionTutorial.pm
* lib/SessionTutorial/Controller/SessionTutorial.pm
* templates/tutorial/start.html.ep

## script/session_tutorial

The startup script uses the line `Mojolicious::Commands->start_app('SessionTutorial')` to tell
Mojolicious to look in the `lib` directory for `SessionTutorial.pm`.  When we generate
the app, it knows where it looks.  No changes necessary here.

## lib/SessionTutorial.pm

Straight out of the box, it looks like this.
Like any module, it starts with the package line.  
```
package SessionTutorial;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  my $self = shift;

  # Load configuration from hash returned by "my_app.conf"
  my $config = $self->plugin('Config');

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer') if $config->{perldoc};

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('example#welcome');
}

1;
```
change `$r->get('/')->to('example#welcome');`
to `$r->get('/')->to('SessionTutorial#start');` and add a new route
`$r->get('/login')->to('SessionTutorial#login');`

The route to the controller has two parts.  
The `SessionTutorial` before the `#` looks for `lib/SessionTutorial/Controller/SessionTutorial.pm` 
and looks for a sub in the controller file with the same name as the part following the `#` sign,
eg. `start` runs the `start` action (or subroutine) in the controller file.

## lib/SessionTutorial/Controller/SessionTutorial.pm
Rename `lib/SessionTutorial/Controller/Example.pm` to `lib/SessionTutorial/Controller/SessionTutorial.pm`,
change the package name, rename the welcome method to start and change the message
to end up like this


```
package SessionTutorial::Controller::SessionTutorial;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub start {
  my $self = shift;

  # Render template "tutorial/start.html.ep" with message
  $self->render(msg => 'Creating a Login Page');
}

1;
```

## templates/tutorial/start.html.ep

This is the default destination for your route's action that we set in
`lib/SessionTutorial.pm`.  You can either rename `welcome.html.ep` 
or `mkdir templates/tutorial` and create a file called `start.html.ep`
with the following content.

```
% layout 'default';
% title 'Mojolicious Session Tutorial - Page 1';
<h2><%= $msg %></h2>
This is the starting page for the first step of the Mojolicious Session Tutorial
```

# Try it out
If you've not already started the server with
```
morbo script/session_tutorial
```
do so now and have a look at your new Start page on 
[localhost:3000/](http://localhost:3000/).

### Morbo - the webserver for development
If `morbo` has been running since [Getting Started](Getting_Started.md),
you'll notice that the changes you've made to the Controller were loaded
as soon as you saved the updated file.  How's that for a time saver?

## add a new route
Let's add a Login page.  Start with putting in a link to it on the Start
page `templates/tutorial/start.html.ep` at the bottom.
```
<p>
This is a link to the
%= link_to Login => 'login'
page (which we should put into a navigational menu later)
``` 

Add a route in `lib/SessionTutorial/Controller/SessionTutorial.pm` for `login`
```
sub login {
  my $self = shift;

  # Render template "tutorial/login.html.ep" with message
  $self->render(msg => 'Login required');
}
```
and a new template `templates/tutorial/login.html.ep` with a skeleton form
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
script/session_tutorial test t/basic.t
```

# Next Step

Clicking on the Login button takes you to a page that doesn't exist
yet where we will need to check the user's credentials
using the instructions in [Authenticate](Authenticate.md)

## More information

More on rendering and validating forms can be found on 
[Mojolicious::Guides::Rendering](http://localhost:3000/perldoc/Mojolicious/Guides/Rendering)
