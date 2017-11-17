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
I've changed this template to use the new `branded` layout 
and used the `stylesheet` helper to load the 
[Bootstrap CSS](https://getbootstrap.com/) 
which has a lot of useful stuff.
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
We should also do this to the `welcome.html.ep` template.  If we end up doing
this to many templates, it feels like something that should move to a layout.
Your choice.

## public/
For your own site, it might help to create `styles`, `js` and `images`
directories under `public` to keep everything organized.


# Try it out

Authenticate at the [Login page](https://localhost:3000/login)
and look for the Logout link at the top right of the page.
Feel smug at the mounting Laziness of rolling out site-wide UI changes
with minimal effort.

If you haven't got the Bootstrap stylesheet loaded, the logout link and Mojolicious logo
will appear on the left side and the horizontal rule will extend across the page.
You could do it yourself with the following code at the top of `templates/????/????`
```
%= stylesheet begin
  .pull-right {float: right}
% end
```
which looks a little messy, but works and shows you how to add your own CSS to the page.

# Test the app

_TODO - could use the css selectors in Test::Mojo_


```
script/session_tutorial test 
```


# Next Step

If a user asked for a protected page, it's only polite to return them to that page
after they have authenticated.
Instructions continue in [Redirect](Redirect.md).

## More information

* [Layouts](http://mojolicious.org/perldoc/Mojolicious/Plugin/DefaultHelpers#layout)
* [JavaScript and Stylesheet helpers](http://mojolicious.org/perldoc/Mojolicious/Plugin/TagHelpers)
* [Mojo::Template](http://mojolicious.org/perldoc/Mojo/Template)
* Test::Mojo [element_exists](https://metacpan.org/pod/Test::Mojo#element_exists) for checking style.

And in various examples in the 
[Mojolicious::Guides::Cookbook](http://mojolicio.us/perldoc/Mojolicious/Guides/Cookbook)
