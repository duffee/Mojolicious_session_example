# Re-directing

_sigh - what do I want to say here?_

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
