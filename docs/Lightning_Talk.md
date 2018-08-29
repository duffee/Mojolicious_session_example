# Learning to Manage Sessions with Mojolicious - Lightning talk

**Tl;dr - we need more Hubris - specifically intermediate Hubris**

There’s plenty of good, basic documentation and there is sufficient high-level 
documentation to make things work, but it’s all over the place.
I'd like to help people take that next step towards building more advanced applications
and improve their (and my) understanding of how Mojolicious and MVC work.
There is a gap in the mid-level documentation of tutorials that do something more complicated.

This tutorial was born out of me having to add authentication to an app.  It is the rubber duck
to whom I explained what I was doing as a check of what I actually understood.
Hopefully, the next person starting out adding sessions to their App can now
finish quicker and tell me how to do it better.


I told $work that I was staying on Saturday to hack, so if this talk interests you,
perhaps we can make it better.


## Steps required to add Authentication to your App

* Login page - in templates
* Route to Login
* Controller
 * Checks credentials
  * If authenticated
    * set session cookie
    * Go to Home page or re-direct to calling page
   * If failed
    * Sleep 3 seconds
    * Count number of failures
    * Block access if too many failures
    * Return to Login page with message
* How to protect a set of pages
* Write the login success/failure to a logfile
* Create a logout link on your layout
* Route to Logout
* Controller removes session cookie and redirects to leaving page
* Write tests to check authentication, access control
 * Having issues with using a test account in the code
 * Use a config file instead of $HARNESS_ACTIVE

Also consider:
* changing the authentication from LDAP to OAuth2
* using a config file to store authentication server credentials
* Use https
* How to write tests better - don’t have test-specific code in the app


## Steal This Tutorial

I use this code to:
* understand the concepts in the documentation - nothing finds gaps like having to explain to an audience
* help others answer my questions - usually _Why doesn't this part **here** work the way I think it should?_
* as a test bed to try out new features (such as OAuth2)

But what if you want to do something else?
Here's a few ideas of where you could take the code and make it your own.

* Grab the end product and re-write the tutorial like a code review

or forget the tutorial and just write code

* Provide a template **lib/App/Controller/Authenticate.pm** and tell people how to use it
* Re-write MojoX::Auth::Simple to handle LDAP
 * Abstract out an Auth base class to handle common methods for Simple, LDAP, OAuth2, etc
* Auto-generate templates with mojo generate session_app (yours to write)

Don't forget to document.


## Other modules to look at

These modules implement authorization with Mojolicious.  I haven't had the time to evaluate
them, but some of them could serve as a better starting point for accomplishing more generalized
authentication or as inspiration for how re-invent a better wheel.

* [MojoX::Auth::Simple](https://metacpan.org/pod/MojoX::Auth::Simple) - passwords stored in DB
* [MojoX::Session](https://metacpan.org/pod/MojoX::Session)
* [Yancy::Plugin::Auth::Basic](https://metacpan.org/pod/Yancy::Plugin::Auth::Basic) - new CMS for Mojolicious
* [Mojolicious::Plugin::OAuth2](https://metacpan.org/pod/Mojolicious::Plugin::OAuth2) - haven’t had time to look at it
* [OAuth::Cmdline::Mojo](https://metacpan.org/pod/OAuth::Cmdline::Mojo) - not much documentation
* [WWW::OAuth::Request::Mojo](https://metacpan.org/pod/WWW::OAuth::Request::Mojo)
* [Mojolicious::Plugin::OpenAPI::Security](https://metacpan.org/pod/Mojolicious::Plugin::OpenAPI::Security)

