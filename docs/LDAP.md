# LDAP

Passwords sent in the clear are a bad idea.  How do we force our application
to use HTTPS?  Start with a new app
```
mojo generate app LDAP	# I've already done this bit
cd ldap
```

## lib/LDAP/Controller/Login.pm

I'm going to rip out the example stuff from the `check_credentials` method
and replace it with an LDAP authorization call.

* check to see if they've provided a username and throw an error if not

* I assume there's only one match for the username because I only check the first result

#### continue from here ####



# Try it out
First copy the file `ldap_config.sample.yml` to `ldap_config.yml` and edit
the values to connect to your LDAP server.

Start the server with
```
morbo -l 'https://*:3000?cert=./server.crt&key=./server.key' script/ldap
```
and click through the Login link on [localhost:3000/](https://localhost:3000/)
to get to the [Login page](https://localhost:3000/login)

# Test the app

Of course, the tests for and requiring logins will fail using pure LDAP authentication
because my example logins aren't in your LDAP.

```
script/ldap test 
```


# Next Step

Now that passwords are secure flying across the net, let's hook it up with
a real authentication source.  Instructions continue in [LDAP](LDAP.md).

## More information

* [Authentication, Helpers and Plugins](http://mojocasts.com/e3 'Mojocast Episode 3')
by Glen Hinkle.
* [Mojolicious::Plugin::BasicAuthPlus]
(https://metacpan.org/pod/Mojolicious::Plugin::BasicAuthPlus)
* [Net::LDAP](https://metacpan.org/pod/Net::LDAP)
* [URI::ldap](http://mojolicio.us/perldoc/URI/ldap)
And of course, the [Mojolicious::Guides::Cookbook]
(http://mojolicio.us/perldoc/Mojolicious/Guides/Cookbook#Basic-authentication)
