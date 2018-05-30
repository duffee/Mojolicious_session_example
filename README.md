# Mojolicious session example
A simple Mojolicious application example for authenticating a user and maintaining a session.

_**A Work In Progress - Not Ready for Production Use**_  I am still soliciting comments.

Quick link for the Impatient to [Getting Started](docs/Getting_Started.md) on the example.

# London Perl Workshop 2017
If you've come here following the spamvertised links at the coffee break table,
you'll find a tutorial in need of improvement, which _you can provide 
[through your comments](docs/CONTRIBUTING.md)!_
Either raise an [issue](https://github.com/duffee/Mojolicious_session_example/issues) 
on Github or email me at **b.duffee at keele dot ac.uk**.

**I am not an expert.**
This tutorial is the result of learning to put together a website with authenticated access
and having to try out a few ideas after reading the documentation.
I use it as a sandbox meaning that it follows my train of thought, 
so it backtracks now and then as I learn something new (like Config files).
You'll also see where I've run out of steam when TODOs start popping up in the text.
The documentation seems more oriented towards getting users up and running quickly 
with Mojolicious::Lite or for advanced developers.  I feel there's a gap in the middle.

### [How you can help](CONTRIBUTING.md)

Pointing out parts that are confusing would be a great help.
I would welcome anything that identifies how a section could be clearer,
explainations of best practice, where I've missed something or what it just plain **wrong**.
I realize that some berks will blindly cut and paste these examples into their code 
and I really _don't_ want the reputation of 
[Matt's Script Archive](https://en.wikipedia.org/wiki/Matt%27s_Script_Archive). 

# What you can find here

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
* create a logout link and place it on your [templates](docs/Templates.md)
* [re-direct](docs/Redirect.md) to previous page after successful authentication
* [protect your login page](docs/Authenticate2.md) against brute force attacks

if we get time we will show you how to
* use a [config file](docs/Config.md) to store system values
* add a plugin module, such as Mojolicious::Plugin::OAuth2 and configure it
* speed up serving dynamic web pages using a cache, such as 
[Redis](https://metacpan.org/pod/MojoX::Redis2)

Instructions on how to build this application are found in **docs/**.
The first step is in [Getting_Started](docs/Getting_Started.md).

## How to use this tutorial

You can read everthing on Github or clone this repository to your machine.

You can access the material in at least three ways:
* Read the docs starting at [Getting_Started](docs/Getting_Started.md) and follow the instructions
* Look at the code for the app built with the instructions in [session_tutorial](session_tutorial)
* Dive into the [Snapshots](Snapshots) directory to look at the app at various stages of the build

If you've cloned the repository, you can immediately run the final app in the **session_tutorial**
directory or if you want to see a working example of the Step that you're currently reading, change to the 
directory of the same name in the **Snapshots** directory and run the app according to the instructions
in the Step.
