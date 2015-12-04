# LDAP

Passwords sent in the clear are a bad idea.  How do we force our application
to use HTTPS?  Start with a new app
```
mojo generate app LDAP	# I've already done this bit
cd ldap
```


#### continue from here ####



# Try it out
Start the server with
```
morbo -l 'https://*:3000?cert=./server.crt&key=./server.key' script/ldap
```
and click through the Login link on [localhost:3000/](https://localhost:3000/)
to get to the [Login page](https://localhost:3000/login)

# Test the app

Make sure we can maintain sessions 

```
script/ldap test 
```


# Next Step

Now that passwords are secure flying across the net, let's hook it up with
a real authentication source.  Instructions continue in [LDAP](LDAP.md).

## More information

[Authentication, Helpers and Plugins](http://mojocasts.com/e3 'Mojocast Episode 3')
by Glen Hinkle.
[Mojolicious::Plugin::BasicAuthPlus]
(https://metacpan.org/pod/Mojolicious::Plugin::BasicAuthPlus)
[URI::ldap](http://mojolicio.us/perldoc/URI/ldap)
Of course, the [Mojolicious::Guides::Cookbook](http://mojolicio.us/perldoc/Mojolicious/Guides/Cookbook#Basic-authentication)
