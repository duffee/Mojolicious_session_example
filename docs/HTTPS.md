# HTTPS

Passwords sent in the clear are a bad idea.  How do we force our application
to use HTTPS?  Start with a new app
```
mojo generate app HTTPS	# I've already done this bit
cd https
```

## Why not use HTTPS everywhere?
That's a very good question and makes this step unnecessary.  Have a look
at the [Cookbook](http://localhost:3000/perldoc/Mojolicious/Guides/Cookbook#Basic-authentication1)
under Applications and a few other places for this
```
script/https daemon -1 'https://*:3000?cert=./server.crt&key=./server.key'
```
But if https everywhere makes your app run slow, continue.

## Mixed http/https usage
**Still not sure how this is done, but this might be a starting point**

` $c->req->url->base->scheme('https') `
or `$c->url_for()-> ... ->scheme('https')`


#### continue from here ####



# Try it out
Start the server with
```
morbo script/https
```
and click through the Login link on [localhost:3000/](http://localhost:3000/)
to get to the [Login page](http://localhost:3000/login)

# Test the app

Make sure we can maintain sessions 

```
script/https test 
```



# Next Step

The bare bones are in place.  The next step is to secure the passwords flying across the net.
Instructions continue in [SSL](SSL.md).

## More information

Detail on sessions can be found in the 
[online documentation](http://localhost:3000/perldoc/Mojolicious/Controller#session 'Mojolicious::Controller').
More on forms and logins can be found on Oliver Günther's [Applications with Mojolicious Series]
(http://oliverguenther.de/2014/04/applications-with-mojolicious-part-three-forms-and-login/ 'Forms, Logins')
