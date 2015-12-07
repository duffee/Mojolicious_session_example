# LDAP

We've made sure that the passwords are sent securely.  How about checking them
against a common authentication method, like LDAP?  Start with a new app
```
mojo generate app LDAP	# I've already done this bit
cd ldap
```

## lib/LDAP/Controller/Login.pm

I'm going to rip out the example stuff from the `check_credentials` method
and replace it with an LDAP authorization call.

### ldap_config.yml
I put all my LDAP server config values in a file called `ldap_config.yml` and
put it in the top level of the app.
`baseDN` is the DN of the tree where you search for users, `username` is the name of 
the attribute that you'll be filtering on and `id` is the name of the identifier
of the LDAP entry (usually `dn`).

This gets loaded into the file and populates the `$config` hashref on line 23.
I used YAML because it's included in the Perl core.

### `check_credentials()`
The first thing I do is make sure there's a `$username`.  An empty return is good for
indicating a failed login.
Line 30 is just there so that the test passes and should be removed from a production
system, unless you want the backdoor there.
`Net::LDAP->new` makes a connection to an LDAP server and `search`, searches the `base_DN`
for `username=$username` and returns the `id` attribute for the user, if one exists.
`return` if you don't have an `id` (line 40) or non-existant people can login.
Finally, bind to LDAP as the user with the password (line 43) and check the result.
I imported the constant `LDAP_INVALID_CREDENTIALS` from Net::LDAP and checked 
the return code of the bind.

On line 39 when I pop the first entry off the search results, I am assuming that
there's only one match for the username because I only check the first result.
This feels right, but perhaps not for everyone.

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
because my example logins aren't in your LDAP.  Nothing stopping you from removing
the dummy login and using a test account of your own to make sure that the
app is connecting to your LDAP correctly.

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
