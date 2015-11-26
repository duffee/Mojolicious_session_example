# Sessions

To keep things clean, I've started a new app called Login
so that we can play with a new set of files that don't 
conflict with the other stages.  As a result you can run 
any of the stages by just stopping the morbo server and 
starting a different startup script.

```
mojo generate app Sessions	# I've already done this bit
cd sessions
```

We'll look at these 3 files
* lib/Authenticate.pm
* lib/Authenticate/Controller/Login.pm
* templates/login/welcome.html.ep

## lib/Authenticate.pm

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
script/authenticate test 
```

# Change the Secret Passphrase

It's advisable to change the Secret Passphrase
that is used in security features such as signed cookies, which we're using to keep sessions.
Add
```
$self->secrets(['El Cementerio de los Libros Olvidados']);
```
to `lib/Sessions.pm`.


# Next Step

Now that we can maintain sessions, let's make sure that private pages aren't visible after logout.
Instructions continue in [Logout](Logout.md).

## More information

More on forms and logins can be found on Oliver Günther's [Applications with Mojolicious Series]
(http://oliverguenther.de/2014/04/applications-with-mojolicious-part-three-forms-and-login/ 'Forms, Logins')
