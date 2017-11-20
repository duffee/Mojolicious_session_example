# Mojolicious session example
A simple Mojolicious application example for authenticating a user and maintaining a session.

_**A Work In Progress**_

# London Perl Workshop 2017
If you've come here following the spamvertised links at the coffee break table,
you'll find a tutorial in need of improvement, which _you can provide through your comments!_
Either raise an issue on Github or email me at b.duffee at keele dot ac.uk.

This tutorial is the result of learning to put together a website with authenticated access
and having to try out a few ideas after reading the documentation.
I use it as a sandbox meaning that it follows my train of thought, 
so it backtracks now and then as I learn something new (like Config files).

Pointing out parts that are confusing would be a great help.
I would welcome anything that identifies how a section could be clearer,
explainations of best practice or where I've missed something.

## What you can find here

This example will show you how to 
* [set up](docs/Getting_Started.md) a Mojolicious application
* create a [login page](docs/Login.md)
* add simple [authentication](docs/Authenticate.md)
* re-direct to a landing page on successful login
* return to login page with message on failed login
* where to place pages that require authenticated access
* restrict access to protected pages using [session cookies](docs/Sessions.md)
* where to place pages that are publically accessible
* add authentication via [LDAP](docs/LDAP.md)
* write to a [logfile](docs/Logging.md)

if we get time we will show you how to
* re-direct to previous page after successful authentication
* create a logout link and place it on your templates
* use a config file to store system values
* add a plugin module, such as Mojolicious::Plugin::OAuth2 and configure it

Instructions on how to build this application are found in **docs/**.
The first step is in [Getting_Started](docs/Getting_Started.md).

## How to use this tutorial

You can access the material in at least three ways:
* Read the docs starting at [Getting_Started](docs/Getting_Started.md) and follow the instructions
* Look at the code for the app built with the instructions in [session_tutorial](session_tutorial)
* Dive into the [Snapshots](Snapshots) directory to look at the app at various stages of the build
