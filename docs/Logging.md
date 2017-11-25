# Writing to Logs

You are serious about security auditing, so you want to log access to your app.  

I've added 
[Mojo::Log](https://metacpan.org/pod/Mojo::Log)
to the Controller.  I could have used
[Mojolicious::Plugin::AccessLog](https://metacpan.org/pod/Mojolicious::Plugin::AccessLog)
which is simpler - not sure why I decided on `Mojo::Log`.

## lib/SessionTutorial/Controller/Tutorial.pm

At the top of the controller, I add
```
use Mojo::Log;

my $log = Mojo::Log->new(path => 'log/access.log', level => 'info');
```
and in the `on_user_login` method, I write to the log with
```
  if (check_credentials($self, $username, $password)) {
	
    $log->info(join "\t", "Login succeeded: $username", $self->tx->remote_address);

  }
  else {
    $log->info(join "\t", "Login FAILED: $username", $self->tx->remote_address);
  }
```
Because you can run as many logs for many different purposes, 
I create a log directory to keep them in with `mkdir log` .
I use the `join` in the call to `log` because the method puts each list item
on a separate line.

Notice that you now also get `log/development.log` for free.
This log stores all the messages from `morbo` such as routing and rendering.
If you're running `hypnotoad` in a production environment, the log name will
be `log/production.log`, naturally.

_TODO - add link to hypnotoad and explain_

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

A navigational menu helps the user get where they want quickly.
Let's move the `Logout` link to a template to make it available from all protected pages.
Instructions continue in [Templates](Templates.md).

## More information
There are a number of blogs and pages that
will get you going with logging.  Perhaps the quickest is
[Mojolicious::Plugin::AccessLog](https://metacpan.org/pod/Mojolicious::Plugin::AccessLog),
a plugin to easily generate an access log.  You only need to consider where the
log will be and whether you want to customize the log format.  It's a one line command
in both Mojolicious and Mojolicious::Lite.

* [Mojo::Log](http://mojolicious.org/perldoc/Mojo/Log)
* [Mojolicious::Plugin::AccessLog](https://metacpan.org/pod/Mojolicious::Plugin::AccessLog) for simple no-brainer logging
* [Mojolicious::Plugin::Log::Access](https://metacpan.org/pod/Mojolicious::Plugin::Log::Access)
* [Nyble's blog](http://pseudopoint.net/wp/?p=190)
* [Logging and Testing](https://groups.google.com/forum/#!topic/mojolicious/X09J7ms7MQw)
* [tempire's blog](http://blogs.perl.org/users/tempire/2011/02/logginz-ur-console-with-mojolicious.html)

And in various examples in the 
[Mojolicious::Guides::Cookbook](http://mojolicio.us/perldoc/Mojolicious/Guides/Cookbook)
