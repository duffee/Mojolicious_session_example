# NOT READY YET, JOEL

# A pre-Christmas Diet for Mojolicious

(image of a Christmas pudding with cream, maybe flaming)

You've just read
[How to lose Weight in the Browser](https://browserdiet.com)
and you want to know to slim down your Mojo app.
Part of that process is preventing the browser from requesting files
that hardly change.
I spent a well-caffienated afternoon trying to do that with
Mojolicious.
I've been 'round the houses, and _spoiler alert_ I didn't find 
the answer until the end, kind of like your favourite Christmas
animated special with a small woodland creature narrating
"The Gruffalo's HTTP header".

---

The small woodland creature needed to display a web calendar with events pulled from a database.
Perl can get the event data and package it as a JSON feed,
with Mojolicous to prepare the webpages with the correct JSON feed for each user
and some javascript libraries to display the web calendar,
all would be well in the forest.
Everything except the javascript libraries are lightweight.
A page reload goes so much faster if it doesn't have to download the
javascript every time.  Those libraries won't change for months!
If only the client browser knew that it could use the file that it had downloaded
last time.

The secret, of course, is to set the `Cache-Control` field of the HTTP header, but _how_?

## First, there was a [Horse](https://httpd.apache.org/) ...

Everybody using Apache would be thinking about using
[mod_expires](https://httpd.apache.org/docs/2.4/mod/mod_expires.html)
which looks quite easy, except I'm not using Apache to serve my pages.

... but the Horse mentioned where there were some sweet
[Cache-Control directives](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cache-Control)
to munch on and while continuing to graze on some
[HTTP Caching](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/http-caching)
pages that had been downloaded earlier.  I moved on.

## and _then_ there was a [Toad](https://perlmaven.com/deploying-a-mojolicious-application)

I use the [Hypnotoad](https://github.com/mojolicious/mojo/wiki/Hypnotoad-prefork-web-server)
web server that comes with Mojolicious to serve my pages.
I find it a good fit for my production environment.

It can set the HTTP headers to turn it into a
[reverse proxy](https://mojolicious.org/perldoc/Mojolicious/Guides/Cookbook#Hypnotoad),
but a popular setup is sitting Hypnotoad behind Nginx or Apache/mod_proxy.
Those servers should let you play with the ```Expires``` header.
But the Toad didn't _quite_ have what I was looking for.

No, I didn't mention
[Plack](https://metacpan.org/pod/Plack).
Maybe if I'm good this year, Santa will
[tell me how](http://blogs.perl.org/users/aristotle/2018/11/modern-perl-cgi.html)
I should be using it.  Probably something to do with
```perl
Plack::Response->header('Expires' => 'Tue, 25 Dec 2018 07:28:00 GMT');
```
but I wouldn't know.

## and _then_ there was a Unicorn ... Mojo::Headers

Well, that was easy.  Just use the standard
[Mojo::Headers](https://mojolicious.org/perldoc/Mojo/Headers#expires)
module to set the ```Expires``` header.

But, wait!  That sets it for the page which isn't fat at all.
You only want to stop the javascript files from reloading every single time
and killing your mobile audience.

##  and _then_ there was a Rhino ... ```defer``` and ```async```

tell your script to load after the main page
with
```
%= script defer 
TODO check syntax
```

## ... and finally, there was a Man in a Hat

But the javascript needs to load **FIRST**!

Sigh - you _really_ want the world on a plate.

Well ... if you must, you'll need to install the
[StaticCache plugin](https://metacpan.org/pod/Mojolicious::Plugin::StaticCache)
written for you only last year by
[Luc Didry](https://fiat-tux.fr/).
It sets the ```Control-Cache``` header for all static files served by Mojolicious.
With your javascript and css files in the ```public``` directory,
they should only be downloaded once and use the cached version until it expires.
The default **max-age** is 30 days and 
if you want you can even cache during development with ```even_in_dev => 1```.

## Try it out

The [Browser calories](https://github.com/zenorocha/browser-calories)
plugin for Firefox, Chrome and Opera breaks down the file sizes of your web page
into a nice little traffic light report measuring the HTML, images, CSS, JavaScript
and other parts of your page against
user-configurable limits on what you think is acceptable.

Google's [PageSpeed Insights](https://developers.google.com/speed/pagespeed/insights)
measures performance on both mobile and desktop.
