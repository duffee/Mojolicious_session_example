# Sessions

I've created a new app to show how to protect pages.
```
mojo generate app Sessions	# I've already done this bit
cd sessions
```

We'll look at these 3 files
* lib/Sessions.pm
* lib/Sessions/Controller/Login.pm
* templates/secure/welcome.html.ep

## templates/secure/welcome.html.ep
I've moved the welcome page to a new directory called `secure` where we'll
put pages that require authorization.

**But it doesn't work there** revert the move

## lib/Sessions/Controller/Login.pm
Add in these lines to the `on_user_login` method before rendering the page
```
    $self->session(logged_in => 1);             # set the logged_in flag
    $self->session(username => $username);      # keep a copy of the username
    $self->session(expiration => 600);          # expire this session in 10 minutes
```
and change the route to `return $self->render(user => $username, template => 'secure/welcome')`
to reflect the changed location of the welcome page.  **Don't do that**

#### NOTES ####
That's been a faff trying to get `under` working

#### END #####

# How `under` works
First you need to define a route like these two protected pages
```
  my $authorized = $r->under('/secure')->to('Secure#is_logged_in');
  $authorized->get('/protected')->to('Secure#protected');
  $authorized->get('/admin')->to(template => 'secure/admin');
```
The `$authorized` object now acts like its root is `/secure`, so to get to the
template `secure/admin` you need the url `http://localhost:3000/secure/admin`.
Likewise, the url `http://localhost:3000/secure/protected` will be routed
to the `protected` method of Secure.pm.

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
morbo script/sessions
```
and click through the Login link on [localhost:3000/](http://localhost:3000/)
to get to the [Login page](http://localhost:3000/login)

# Test the app

Make sure we can maintain sessions 

```
script/sessions test 
```

# Change the Secret Passphrase

It's advisable to change the Secret Passphrase
that is used in security features such as signed cookies, which we're using to keep sessions.
It cryptographically signs the cookie to prevent tampering, but since anyone can know that
the default passphrase is `
Add
```
$self->secrets(['El Cementerio de los Libros Olvidados']);
```
to `lib/Sessions.pm`.


# Next Step

Now that we can maintain sessions, let's make sure that private pages aren't visible after logout.
Instructions continue in [Logout](Logout.md).

## More information

Detail on sessions can be found in the 
[online documentation](http://localhost:3000/perldoc/Mojolicious/Controller#session 'Mojolicious::Controller').
More on forms and logins can be found on Oliver Günther's [Applications with Mojolicious Series]
(http://oliverguenther.de/2014/04/applications-with-mojolicious-part-three-forms-and-login/ 'Forms, Logins')