# LDAP

We've made sure that the passwords are sent securely.  How about checking them
against a common authentication method, like LDAP?

## lib/SessionTutorial/Controller/Tutorial.pm

I'm going to rip out the example stuff from the `check_credentials` method
and replace it with an LDAP authorization call.

### ldap_config.yml
I put all my LDAP server config values in a file called `ldap_config.yml`
and put it in the top level of the app.
`baseDN` is the DN of the tree where you search for users, `username` is the name of 
the attribute that you'll be filtering on and `id` is the name of the identifier
of the LDAP entry (usually `dn`).

This gets loaded into the file and populates the `$config` hashref in the following code
added to the top of the file along with the module dependancies.
```
use Net::LDAP qw/LDAP_INVALID_CREDENTIALS/;
use YAML qw/LoadFile/;

my $config = LoadFile('ldap_config.yml');
my ($LDAP_server, $base_DN, $user_attr, $user_id, )
        = @{$config}{ qw/server baseDN username id/ };
```
I used YAML because it's included in the Perl core and I was used to it.
Mojolicious has a **Config** plugin that I'll look at later.

### `check_credentials()`
Replace the body of `check_credentials()` with the following
```
  my ($username, $password) = @_;
  return unless $username;
  return 1 if ($username eq 'julian' && $password eq 'carax');

  my $ldap = Net::LDAP->new( $LDAP_server )
        or warn("Couldn't connect to LDAP server $LDAP_server: $@"), return;

  # Escape special chacarters in the username
  $username =~ s/([*()\\\x{0}])/sprintf '\\%02x', ord($1)/ge;
  my $search = $ldap->search( base => $base_DN,
                              filter => join('=', $user_attr, $username),
                              attrs => [$user_id],
                            );
  my $user_id = $search->pop_entry();
  return unless $user_id;

  my $login = $ldap->bind( $user_id, password => $password );

  return $login->code == LDAP_INVALID_CREDENTIALS ? 0 : 1;
```
The first thing I do is make sure there's a `$username`.  An empty return is good for
indicating a failed login.
The third line is just there so that the test passes and should be removed from a production
system, unless you want an alternate authentication method there.
Following the
[best practices for LDAP authentication](https://ltb-project.org/documentation/general/auth_ldap_best_practices),
`Net::LDAP->new` makes a connection to an LDAP server and `search`, searches the `base_DN`
for `username=$username` and returns the `id` attribute for the user, if one exists.
`return` if you don't have an `id` (line 40) or non-existent people can login.
Finally, bind to LDAP as the user with the password (line 43) and check the result.
I imported the constant `LDAP_INVALID_CREDENTIALS` from Net::LDAP and checked 
the return code of the bind.

When I pop the first entry off the search results, I am assuming that
there's only one match for the username because I only check the first result.
This feels right, but perhaps not for everyone.

### `is_logged_in()`
Ooops!  I forgot that this method checked for a valid username, but those names aren't in
my LDAP, so I needed to make the following changes.
```
my $allowed_user_re = qw/^\w{5,10}$/;

sub is_logged_in {

  return 1 if $self->session('logged_in') && $self->session('username') =~  /$allowed_user_re/;


  return;
}
```
Second ooops - an old version of this method ended with rendering a page saying Unauthorized Access.
Having failed, we should ensure that the method returns false (the bare `return;` at the end returns
undef in scalar context and the empty list in list context, both evaluate to false)

# Try it out
First copy the file `ldap_config.sample.yml` to `ldap_config.yml` and edit
the values to connect to your LDAP server.

Start the server with
```
morbo -l 'https://*:3000?cert=./server.crt&key=./server.key' script/session_tutorial
```
and click through the Login link on [localhost:3000/](https://localhost:3000/)
to get to the [Login page](https://localhost:3000/login)

# Test the app

Of course, the tests for and requiring logins will fail using pure LDAP authentication
because my example logins aren't in your LDAP.  Nothing stopping you from removing
the dummy login and using a test account of your own to make sure that the
app is connecting to your LDAP correctly.

_The correct procedure is to "mock" the LDAP server, removing the dependancy on a
live LDAP server and a valid account that lives in your test suite._

You'll need to have `Test::Net::LDAP::Mock` installed to run the test

```
script/session_tutorial test 
```

-stolen from [Joel](https://mojolicious.io/blog/2017/12/09/day-9-the-best-way-to-test/index.html)

When instantiating a Full app you can actually pass it a second argument, a hash reference of configuration overrides. This can be especially handy for overriding things like database parameters to access a test instance rather than your regular database.

so
```perl
my $t = Test::Mojo->new('MyApp', {pg => 'postgresql://testuser:testpass@/testdb'});
```

# Next Step

If you're serious about security, you will start to consider logging access to your app.
Instructions continue in [Logging](Logging.md). 

## More information

* [Net::LDAP](https://metacpan.org/pod/Net::LDAP)
* [Perl LDAP](http://ldap.perl.org/)
