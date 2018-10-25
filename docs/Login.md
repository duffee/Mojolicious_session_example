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
```perl
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
to `$r->get('/')->to('Tutorial#start');` and add a new route
`$r->get('/login')->to('Tutorial#login');`

A [route](http://mojolicious.org/perldoc/Mojolicious/Guides/Routing#CONCEPTS)
directs your request to the code that generates the response.
The route to the controller has two parts.  
The `Tutorial` before the `#` looks for `lib/SessionTutorial/Controller/Tutorial.pm` 
and looks for a sub in the controller file with the same name as the part following the `#` sign,
eg. `start` runs the `start` action (or subroutine) in the controller file.

It should now look like this
```perl
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
  $r->get('/')->to('Tutorial#start');
  $r->get('/')->to('Tutorial#login');
}

1;
```

## lib/SessionTutorial/Controller/Tutorial.pm
Rename `lib/SessionTutorial/Controller/Example.pm` to `lib/SessionTutorial/Controller/Tutorial.pm`,
change the package name on the first line, rename the **welcome** method to **start** 
and change the message to end up like this

```perl
package SessionTutorial::Controller::Tutorial;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub start {
  my $self = shift;

  # Render template "tutorial/start.html.ep" with message
  $self->render(msg => 'Creating a Login Page');
}

1;
```

_TODO - this needs more explanation of how the **action** in the **Controller** is directed to the **template**.  Link to_
[Rendering](http://localhost:3000/perldoc/Mojolicious/Guides/Rendering)


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
You should see

---

>**Creating a Login Page**
>
>This is the starting page for the first step of the Mojolicious Session Tutorial 

---

### Morbo - the webserver for development
If `morbo` has been running since [Getting Started](Getting_Started.md),
you'll notice that the changes you've made to the Controller were loaded
as soon as you saved the updated file.  How's that for a time saver?

## Add a new route
Let's add a Login page.  Start with putting in a link to it on the Start
page `templates/tutorial/start.html.ep` at the bottom.
```
<p>
This is a link to the
%= link_to Login => 'login'
page (which we should put into a navigational menu later)
``` 

Add a route in `lib/SessionTutorial/Controller/Tutorial.pm` for `login`
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

Open `t/basic.t`, 
add `$t->get_ok('/login')->status_is(200)->content_like(qr/Username/i);`
and run
```
script/session_tutorial test t/basic.t
```
which should pass with this message
```
All tests successful.
Files=1, Tests=6,  1 wallclock secs
Result: PASS
```
But the important part is that the form is on the page and that it has
all the elements that we want to pass through, as well as a Submit button.
We can keep chaining tests together.  I've given each test its own line to make it readable.
```
$t->get_ok('/login')
  ->status_is(200)
  ->element_exists('form input[name="username"]')
  ->element_exists('form input[name="password"]')
  ->element_exists('form input[type="submit"]')
  ->content_like(qr/Username/i);
```
now you should see that 9 tests pass when you run the test
```
All tests successful.
Files=1, Tests=9,  1 wallclock secs
Result: PASS
```
Read more about 
[testing Mojolicious applications](http://mojolicious.org/perldoc/Mojolicious/Guides/Testing)

# Next Step

Clicking on the Login button takes you to an error page saying 

---

>**Page not found... yet!** 
>
>None of these routes could generate a response.

---

Now we will need to check the user's credentials
using the instructions in [Authenticate](Authenticate.md)

## More information

More on directing requests to the Controller can be found on
[Mojolicious::Guides::Routing](http://mojolicious.org/perldoc/Mojolicious/Guides/Routing)
More on rendering web pages and validating forms can be found on 
[Mojolicious::Guides::Rendering](http://localhost:3000/perldoc/Mojolicious/Guides/Rendering)
