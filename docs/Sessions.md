# Sessions

This step will show you how to protect your pages by maintaining a Session.

We'll look at these 3 files
* lib/SessionTutorial.pm
* lib/SessionTutorial/Controller/Tutorial.pm
* templates/tutorial/welcome.html.ep

## templates/tutorial/welcome.html.ep

## lib/SessionTutorial/Controller/Tutorial.pm
Add in these lines to the `on_user_login` method before rendering the page
```
    $self->session(logged_in => 1);             # set the logged_in flag
    $self->session(username => $username);      # keep a copy of the username
    $self->session(expiration => 600);          # expire this session in 10 minutes
```

#### NOTES ####
That's been a faff trying to get `under` working

#### END #####

# How `under` works
A full explanation of 
[under](http://mojolicious.org/perldoc/Mojolicious/Guides/Routing#Under)
is in the documentation.

First you need to define a route in **lib/SessionTutorial.pm**
like these two protected pages
```
  my $authorized = $r->under('/secure')->to('Tutorial#is_logged_in');
  $authorized->get('/protected')->to('Tutorial#protected');
  $authorized->get('/admin')->to(template => 'tutorial/admin');
```
The `$authorized` object now acts like its root is `/secure`, so to get to the
template `secure/admin` you need the url `http://localhost:3000/secure/admin`.
Likewise, the url `http://localhost:3000/secure/protected` will be routed
to the `protected` method of Secure.pm.

Of course, you need a ```protected``` action in the ```Tutorial``` controller like
```
sub protected {
  my $self = shift;

  my $username = $self->session('username');
  $self->render(user => $username, template => 'tutorial/protected');
}
```
The third route shows you that you can go directly to a secure template without 
going through the controller.

## private pages in the `/public` directory
So far `public/secure/private_page.html` is visible without a login - Hmmm

## routing to a method in the Secure controller
The `under` directive to the `Secure#is_logged_in` controller doesn't fire
if you send it to a different controller, in my case `Secure#protected`.
In that case you need to check to see if you're logged in inside the `protected`
method.


# Try it out
Start the server with
```
morbo script/session_tutorial
```
and click through the Login link on [localhost:3000/](http://localhost:3000/)
to get to the [Login page](http://localhost:3000/login)

# Test the app

Make sure we can maintain sessions 

```
script/session_tutorial test 
```

# MojoX::Session

If you're concerned that people will mess with your session cookie
in the browser, you can maintain the session on the server-side with
[MojoX::Session](https://metacpan.org/pod/MojoX::Session)
which stores the session in a database.

_I haven't really looked at it yet.  I should._

# Change the Secret Passphrase

_only required for older versions of Mojolicious - older than 6.x_

It's advisable to change the Secret Passphrase
that is used in security features such as signed cookies, which we're using to keep sessions.
It cryptographically signs the cookie to prevent tampering, but since anyone can know that
the default passphrase is `
Add
```
$self->secrets(['El Cementerio de los Libros Olvidados']);
```
to `lib/SessionTutorial.pm`.


# Next Step

Now that we can maintain sessions, let's make sure that private pages aren't visible after logout.
Instructions continue in [Logout](Logout.md).

## More information

Detail on sessions can be found in the 
[online documentation](http://localhost:3000/perldoc/Mojolicious/Controller#session 'Mojolicious::Controller').
More on forms and logins can be found on Oliver G&uuml;nther's
[Applications with Mojolicious](http://oliverguenther.de/2014/04/applications-with-mojolicious-part-three-forms-and-login/ 'Forms, Logins')

_TODO - add link to Sessions and security_
