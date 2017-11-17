# Using Templates

You want a consistent look and feel to your site without maintenance headaches.
You want a navigation menu to follow the user around the site.
You want to customize your **templates** and **layouts**.

More experienced UX developers can explain the rationale for what content
goes in layouts and what goes in templates.  I've made the naive choice
of putting branding logos in the layout and navigation in the templates.
Let me know what works for you.

## templates/layouts/branded.html.ep
I copied the default layout to `branded.html.ep` and added a footer after the body tag.
```
  <body><%= content %></body>
  <footer>
... get it working and then paste it here ...
  </footer>
</html>
```
_some of this may depend on the bootstrap css that gets loaded in the template.
this may not be good practice_

## templates/tutorial/protected.html.ep
I've changed this template to use the new `branded` layout and told it to
load the **Bootstrap CSS** which has a lot of useful stuff.
I've created a menu at the top in the `div` tags which only has
the link to the Logout page.
Now the top of the file looks like this
```
% layout 'branded';
% title 'Mojolicious session example - Page 6?';
%= stylesheet '/styles/bootstrap.min.css'

<div class="top-menu pull-right" style="margin-right:50px;">
%= link_to Logout => '/logout'
</div>

```

# Try it out

Authenticate at the [Login page](https://localhost:3000/login)
and check `log/access.log` for something like 
```
[Thu Nov 16 18:59:16 2017] [info] Login FAILED: francisco	127.0.0.1
[Thu Nov 16 19:01:34 2017] [info] Login succeeded: julian	127.0.0.1
```

# Test the app

_TODO - I can't think of how to write a test that intercepts log messages._

In the test, you can change the log level using
`$t->app->log->level('fatal');`

```
script/session_tutorial test 
```


# Next Step

**This tutorial finishes here.**

Instructions continue in [Redirect](Redirect.md).

## More information
There are a number of blogs and pages that
will get you going with logging.  Perhaps the quickest is
[Mojolicious::Plugin::AccessLog](https://metacpan.org/pod/Mojolicious::Plugin::AccessLog),
a plugin to easily generate an access log.  You only need to consider where the
log will be and whether you want to customize the log format.  It's a one line command
in both Mojolicious and Mojolicious::Lite.

* [Mojo::Log](http://mojolicious.org/perldoc/Mojo/Log)
* [Mojolicious::Plugin::AccessLog](https://metacpan.org/pod/Mojolicious::Plugin::AccessLog)
* [Nyble's blog](http://pseudopoint.net/wp/?p=190)
* [Logging and Testing](https://groups.google.com/forum/#!topic/mojolicious/X09J7ms7MQw)
* [tempire's blog](http://blogs.perl.org/users/tempire/2011/02/logginz-ur-console-with-mojolicious.html)

And in various examples in the 
[Mojolicious::Guides::Cookbook](http://mojolicio.us/perldoc/Mojolicious/Guides/Cookbook)
