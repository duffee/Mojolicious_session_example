# Making a Login page

This is just a plain page, but so that I can show you how to
evolve your app to a fully featured part of the site I have
created a new set of files that don't conflict with the other
stages.  As a result you can run any of the stages by just
stopping the morbo server and starting a different startup
script.

To achieve this affect, I've created a new app in the same directory with these 4 files
* script/login
* lib/Login.pm
* lib/Login/Controller/Login.pm
* templates/login/start.html.ep

## script/login

The startup script uses the line `Mojolicious::Commands->start_app('Login')` to tell
Mojolicious to look in the `lib` directory for `Login.pm`.

## lib/Login.pm

Like any module, it starts with the package line.  
```perl
package Login;

sub startup {

# Normal route to controller
  $r->get('/')->to('login#start');
}
```
The route to the controller has two parts.  The `login` looks for `lib/Login/Controller/Login.pm` 
and the `start` runs the `start` action (sub) in the controller file.

## lib/Login/Controller/Login.pm

```perl
sub start {

  # Render template "login/start.html.ep" with message
  $self->render(msg => 'Creating a Login Page');

}
```

## templates/login/start.html.ep

This is the default destination for your route's action.

```perl
% layout 'default';
% title 'Login example - Page 1';
<h2><%= $msg %></h2>
This is the starting page for the first step of the Session Example
```

# Does this make sense?  Is it correct?
