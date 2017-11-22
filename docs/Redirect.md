# Re-directing

_this is where I get confused about redirecting/rendering_

## lib/SessionTutorial/Controller/Tutorial.pm

When the user fails the `is_logged_in()` method, save the URL of the page in the session cookie
using a parameter I'm calling **calling_page**.
```
sub is_logged_in {
  my $self = shift;

  return 1 if $self->session('logged_in') && $self->session('username') =~  /$allowed_user_re/;

  $self->session(calling_page => $self->req->url);
  $self->render(
    inline => '<h2>Unauthorized access</h2>Please <a href="/login">login</a> first.',
    format => 'html',
    status => 401,
  );
  return undef;
}
```
On successful authentication, check for the parameter **calling_page** and `redirect_to` that page
instead of the default welcome page.
```
sub on_user_login {
  my $self = shift;


  if (check_credentials($username, $password)) {


    $self->redirect_to($self->session('calling_page')) if $self->session('calling_page');
    $self->render(template => 'tutorial/welcome', format => 'html');
  }
```

# Try it out

Logout if you have authenticated and then try to access a 
[protected page](https://localhost:3000/secure/protected)
and see how you are directed to the [Login page](https://localhost:3000/login).
After authenticating successfully, you should be returned to
the protected page, not the welcome page.

# Test the app

_TODO - I have trouble testing the redirect_


```
script/session_tutorial test 
```


# Next Step

**This tutorial finishes here.**

Instructions continue in [Config](Config.md).

## More information

* [Mojo::Template](http://mojolicious.org/perldoc/Mojo/Template)
* Test::Mojo [element_exists](https://metacpan.org/pod/Test::Mojo#element_exists) for checking style.

And in various examples in the 
[Mojolicious::Guides::Cookbook](http://mojolicio.us/perldoc/Mojolicious/Guides/Cookbook)
