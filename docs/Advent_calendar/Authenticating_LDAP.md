# Authenticating with LDAP

There are still quite a few people using LDAP in production,
but for those who are new to it,
LDAP is a directory with a tree-structure that's optimised for very fast lookups.
It used to be very common as a centralised authentication system
and if you're using Active Directory, you're using LDAP (mostly).

This post is based on a
[talk](https://docs.google.com/presentation/d/14ZbARlTj_3mxEf_9Bvbrz0AUYjQdFjIXfYuttb_J7uU)
I gave at
[London Perl Workshop](https://act.yapc.eu/lpw2018)
in 2018.
It's a little optimistic thinking that they'll get through
editing all the videos before Christmas, but we could hope
for an epiphany.
LDAP is just a small part of the authentication cycle here, so
this post generalises fairly well for those cases where you have
to write your own credential checker.
Oh, and the talk and writing this post has done exactly what was intended
and raised issues that I hadn't considered which I've included here.
As a result, it's starting to read like
[Alice's Restaurant](https://en.wikipedia.org/wiki/Alice%27s_Restaurant_Massacree)
without the full orchestration and five part harmony.
I hope this cautionary tale helps you to avoid the same pitfalls that I fell into.

In the meantime, have a
[Lightning Talk](https://www.youtube.com/watch?v=t-BEo467pUI)
from MojoConf 2018.

### Route - lib/MyApp.pm

First off, a confession.  I never really got into Lite Apps.
I know it's [easy](https://www.youtube.com/watch?v=ycAXeOKLCGc)
to [grow them into Full Apps](https://mojolicious.org/perldoc/Mojolicious/Guides/Growing),
but I was under pressure to crank out a solution when I started and never got back to it.
The result is that this post is about authenticating a **Full App** and isn't as
svelte as the other posts talking about their Lite apps.

Jumping straight in, let's assume that you already have a Login page
in your templates and it has a form which posts data to `/login`.
If you've got a route like this
```perl
$r->post('/login')->name('do_login')->to('Secure#on_user_login');
```
to send the credentials to your controller.

_or if you're cool with_
[named routes](https://mojolicious.org/perldoc/Mojolicious/Guides/Routing#Named-routes),
_your template might include this line_
```perl
<form action="<%= url_for 'do_login' %>" method="POST">
```

### Controller - lib/MyApp/Controller/Secure.pm

Let's get started by cribbing from the
[Mojolicious Cookbook](https://mojolicious.org/perldoc/Mojolicious/Guides/Cookbook#Basic-authentication1).

```perl
package MyApp::Controller::Secure;
use Mojo::Base 'Mojolicious::Controller';

sub on_user_login {
  my $self = shift;

  my $username = $self->param('username');
  my $password = $self->param('password');

  if (check_credentials($username, $password)) {
    $self->render(text => 'Hello Bender!');
  }
  else {
    $self->render(
        text => '<h2>Login failed</h2><a href="/login">Try again</a>',
        format => 'html',
        status => 401
    );
  }
}

sub check_credentials {
  my ($username, $password) = @_;

  return  $username eq 'Bender' && $password eq 'rocks';
}
```


## Storing passwords - MojoX::Auth::Simple

We can agree that hard-coding usernames and passwords is not sustainable.
If you can connect to a database, any database that your Perl
[DBI](https://metacpan.org/pod/DBI) module can connect to,
then you might think that
[MojoX::Auth::Simple](https://metacpan.org/pod/MojoX::Auth::Simple)
will solve your problems.  Further reading will tell you that it only
provides the helper methods `log_in`, `is_logged_in` and `log_out`
which are useful for everything around the authentication, but not the
authentication itself.  But, since you're using a database now, you
could change the `check_credentials` to something better than this
(wot was cooked up on a Friday afternoon and not tested)
```perl
sub check_credentials {
  my ($username, $password) = @_;

  my $statement = <<'SQL';	    NO! Don't do this!
SELECT username FROM user_passwd
WHERE username = ? AND password = ?
SQL

  my $sth = $dbh->prepare($statement);
  $sth->execute($username, $password) or return;
  my @row = $sth->fetchrow_array();
  $sth->finish();
  
  return $username eq $row[0];
}
```
with the database connection and handle `$dbh` left as an exercise to the reader.
And yes, you should prepare the SQL outside of the sub.
The `?` in the SQL statement are bind parameters, placeholders that make the database call faster and safer.

#### Did you spot the HUGE mistake I made?

Never, never, NEVER store passwords in plain text!  (Blame it on Friday afternoon)
You should encrypt the password before storing it with an algorithm like AES or SHA-2.
So, how about this for a better untested example

encrypt with SQL
```perl
  my $statement = <<'SQL';      # better
SELECT username FROM user_passwd
WHERE username = ? AND password = SHA2(?, 256)
SQL
```

or encrypt with Perl
```perl
use Crypt::Digest::SHA256 qw/ sha256 /;

sub check_credentials {
  my ($username, $password) = @_;
  my $encrypted = sha256($password);

...

  $sth->execute($username, $encrypted) or return;
```

Technically, AES is an encryption algorithm and SHA-2 is a hashing algorithm,
meaning that the transformation is effectively one-way and is more secure.
Here are a couple of modules that make it easier:

A nice module out there for handling passwords is, well,
[Passwords](https://metacpan.org/pod/Passwords).
It's just a wrapper around some other modules that gives you a simple API
and will use [Bcrypt](https://metacpan.org/pod/Crypt::Eksblowfish::Bcrypt) by default.
So if you've hashed your password with the `password_hash` function
and stored the `$hash` value in your database like this
```perl
my $hash = password_hash($initial_password);

my $sth = $dbh->prepare('INSERT INTO user_passwd (username, password) VALUES (?, ?)');
$sth->do($username, $hash);
```
you should be ok to change the sub to
```perl
sub check_credentials {
  my ($username, $password) = @_;

  my $statement = 'SELECT password FROM user_passwd WHERE username = ?';

  my $sth = $dbh->prepare($statement);
  $sth->execute($username) or return;
  my ($encoded) = $sth->fetchrow_array();
  $sth->finish();
  
  return password_verify($password, $encoded);
}
```


[Mojolicious::Plugin::Scrypt](https://metacpan.org/pod/Mojolicious::Plugin::Scrypt)
will use the Scrypt algorithm,
but can also use Argon2 (which was recommended to me at LPW), Bcrypt and more.
So, assuming that you've stored your password with
`my $encoded = $app->scrypt($password);`
the `on_user_login` sub becomes
```perl
sub check_credentials {
  my ($username, $password) = @_;

  my $statement = 'SELECT password FROM user_passwd WHERE username = ?';

  my $sth = $dbh->prepare($statement);
  $sth->execute($username) or return;
  my ($encoded) = $sth->fetchrow_array();
  $sth->finish();
  
  # WAIT! where did $self come from
  return $self->scrypt_verify($password, $encoded);
}
```
Oh, dear.  The above crashes because of a design decision made early on in the writing process.
I invoked `check_credentials` as a plain sub, not the method of an object.
Using a Plugin depends on having the controller available, so the following changes are necessary.
```perl
sub on_user_login {
  my $self = shift;
...

  if ($self->check_credentials($username, $password)) {
...
}

sub check_credentials {
  my ($self, $username, $password) = @_;
...
  return $self->scrypt_verify($password, $encoded);
}
```
Y'know, I'm sitting here on the Group W bench thinkin' ...
if I'm going to re-write this whole tutorial, maybe I should've started with
[Mojolicious::Plugin::Authentication](https://metacpan.org/pod/Mojolicious::Plugin::Authentication)
and taken you through the code you needed for the `validate_user` option in the Plugin.
But let's leave that for next year.


Further reading on storing passwords:
* [Secure Salted Password Hashing](https://crackstation.net/hashing-security.htm#properhashing) by Defuse Security.

## How to [LDAP](https://metacpan.org/pod/Net::LDAP)

_remember LDAP?  ... this is a post about LDAP_

These are the steps to authenticating:
1. Connect to the LDAP server
2. **Bind** to the server
3. Search for the user's unique identifier in LDAP
4. **Bind** as the user with their password
5. Check the result code from the server

First, you need to make a network connection to the LDAP server.
Next, you [bind](https://metacpan.org/pod/Net::LDAP#METHODS) to the server.
"Bind" is the term used in LDAP for connecting to a particular location
in the LDAP tree.
The LDAP server has a setting on whether it allows binding anonymously
and determines whether you can search directory without a password
as I've done in the example.
Then you search LDAP for the user (because the identifiers are _loooong_)
and then you bind as the user with the password they've provided.
If this connection as the user with their password succeeds,
then you must have used the correct password.
LDAP hands you back a result from the `bind` as a
[Net::LDAP::Message](https://metacpan.org/pod/distribution/perl-ldap/lib/Net/LDAP/Message.pod)
object on either success or failure,
so check the Message `code` to find out whether you should authenticate the user.

Here's the code
```perl
package MyApp::Controller::Secure;
use Mojo::Base 'Mojolicious::Controller';
use Net::LDAP qw/LDAP_INVALID_CREDENTIALS/;
use YAML qw/LoadFile/;

my $config_file = 'ldap_config.yml';
my $config = LoadFile($config_file);

my ($LDAP_server, $base_DN, $user_attr, $user_id, )
        = @{$config}{ qw/server baseDN username id/ }; 

...

sub check_credentials {
  my ($username, $password) = @_;
  return unless $username;

  my $ldap = Net::LDAP->new( $LDAP_server )
        or warn("Couldn't connect to LDAP server $LDAP_server: $@"), return;
  my $message = $ldap->bind( $base_DN );

  my $search = $ldap->search( base => $base_DN,
                              filter => join('=', $user_attr, $username),
                              attrs => [$user_id],
                            );
  my $user_id = $search->pop_entry();
  return unless $user_id;                     # does this user exist in LDAP?

  # this is where we check the password
  my $login = $ldap->bind( $user_id, password => $password );

  # return 1 on success, 0 on failure with the ternary operator
  return $login->code == LDAP_INVALID_CREDENTIALS ? 0
                                                  : 1;
}
```
where you have a file `ldap_config.yml` in the top-level directory that looks a little like
```yaml
# config values for connecting to LDAP
server: 	ldap.example.com
baseDN: 	dc=users,dc=example,dc=com
username: 	userid
id: 		dn
```
where the values on the right match the attributes in your LDAP schema.

Just making the logic clear in the last step, I've imported a constant
from Net::LDAP called `LDAP_INVALID_CREDENTIALS` and I use that to check
against the result from the server.
```perl
use Net::LDAP qw/LDAP_INVALID_CREDENTIALS/;

...

  return ($login->code == LDAP_INVALID_CREDENTIALS) ? 0 : 1;
}
```
The logic is a little back to front with the ternary operator, but
if the code I get from the server is `LDAP_INVALID_CREDENTIALS`
then I return `0`, a fail, otherwise I return `1`,
which is a true value for the `if` in the body of the `on_user_login`
function.

Yes, you're right once again.  I probably should be using
[Mojolicious::Plugin::Config](https://metacpan.org/pod/Mojolicious::Plugin::Config)
to handle config files.  It's on my TODO list.

## Sessions

Want more power managing sessions?  Well then, you want
[MojoX::Session](https://metacpan.org/pod/MojoX::Session)
which will store your sessions in a database as well as giving
you a bunch of accessors to help you fine-tune how your session management.
You can force the session to match on IP address to hinder session hijacking.
or add more data to the session cookie.

It works well with 
[MojoX::Auth::Simple](https://metacpan.org/pod/MojoX::Auth::Simple).
The module documentation page gives you a great example.
You just have to ensure that the name given to
[url_for](https://mojolicious.org/perldoc/Mojolicious/Controller#url_for) in
```perl
<% } else { %>
      <div>Not logged in; <form action="<%= url_for 'login' %>" method="POST">
        <input type="submit" value="Login"></form></div>
    <% } %>
```
(here it's *login*) matches the name you used in your route
```perl
$r->post('/login')->name('do_login')->to('Secure#on_user_login');
```
which I named *do_login*.  Using
[named routes](https://mojolicious.io/blog/2017/12/03/day-3-using-named-routes/)
gives you the flexibility of changing URLs without much hassle.

# notes for Joel

## Author

Boyd Duffee has been hanging around the edges of the Perl ecosystem for many moons,
picking up new bits of shiny to make SysAdmining more interesting.
He's pestered Joel (and a number of other Mojo devs) enough to feel guilted into 
writing an Advent calendar entry.
He's interested in Data Science, Complex Networks and walks in the woods.

## suggested images for the calendar Window

* [eyes](https://commons.wikimedia.org/wiki/File:Eyes_of_a_child_in_the_letter_hole.jpg)
* [keyhole](https://pixabay.com/en/keyhole-old-lock-door-464232/)
* [blue door](https://unsplash.com/photos/_AMz6-Z8GUI)
* [teal door](https://unsplash.com/photos/XtMICJ6MMJk)
* [spy hole](https://en.wikipedia.org/wiki/File:What%27s_the_password.JPG)
* [camera](https://unsplash.com/photos/IhcSHrZXFs4)
* [more doors](https://unsplash.com/search/photos/door), [more locks](https://unsplash.com/search/photos/lock), [more security](https://unsplash.com/search/photos/security)

remove this bit when you publish.
