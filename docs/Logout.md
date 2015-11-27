# Logout

To very quickly show you how to make sure you've logged out of your applicaton,
I've started a new app build on the last one.
```
mojo generate app Logout	# I've already done this bit
cd logout
```

# `lib/Logout.pm`
Just looking at one file this time.  Not bothering to put the code into a 
controller.
```
  $r->route('/logout')->name('do_logout')->to(cb => sub {
    my $self = shift;
    
    $self->session(expires => 1);

    $self->redirect_to('/');
  });

```
Expire the session and then return the user to the home page.


# Try it out
Start the server with
```
morbo script/logout
```
and click through the Login link on [localhost:3000/](http://localhost:3000/)
to get to the [Login page](http://localhost:3000/login)

# Test the app

Make sure we can maintain sessions 

```
script/logout test 
```



# Next Step

The bare bones are in place.  The next step is to secure the passwords flying across the net.
Instructions continue in [SSL](SSL.md).

## More information

Detail on sessions can be found in the 
[online documentation](http://localhost:3000/perldoc/Mojolicious/Controller#session 'Mojolicious::Controller').
More on forms and logins can be found on Oliver Günther's [Applications with Mojolicious Series]
(http://oliverguenther.de/2014/04/applications-with-mojolicious-part-three-forms-and-login/ 'Forms, Logins')
