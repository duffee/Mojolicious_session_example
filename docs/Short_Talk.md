Expanding on the [Lightning Talk](Lightning_Talk.md) I gave at Mojoconf 2018,
this is the outline for the
[Short talk](https://act.yapc.eu/lpw2018/talk/7558) I'm giving at
[London Perl Workshop](https://act.yapc.eu/lpw2018).
It's close to the [Advent calendar post](Advent_calendar/Authenticating_LDAP.md)
I'm writing for Joel.

# Authenticating Mojolicious apps with LDAP

## Routes

### Named Routes

## Controller

## MojoX::Auth::Simple

Not the solution you were looking for.

## LDAP

Load config information either using YAML
or
Mojolicious::Plugin::Config

Authenticating via LDAP
* connect to LDAP server
* search for the user to authenticate
* **bind** as the user using the supplied password
* act on the success or failure returned by the LDAP server

Active Directory (yet another LDAP server) may require you to authenticate
to connect to the server.

## Sessions

Store the session in a cookie or use
MojoX::Sessions
to store them server side.
