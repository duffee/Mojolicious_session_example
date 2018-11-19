# NOT READY YET, JOEL

# A pre-Christmas Diet for Mojolicious

(image of a Christmas pudding with cream, maybe flaming)

You've just read
[How to lose Weight in the Browser](https://browserdiet.com)
and you want to know to slim down your Mojo app.

## Hypnotoad

No, it's not in here.  It can set the HTTP headers to turn it into a
[reverse proxy](https://mojolicious.org/perldoc/Mojolicious/Guides/Cookbook#Hypnotoad)
, but a popular setup is sitting Hypnotoad behind Nginx or Apache/mod_proxy.
Those servers should let you play with the ```Expires``` header.

No, I didn't mention
[Plack](https://metacpan.org/pod/Plack).
Maybe if I'm good this year, Santa will tell me how I should be using it.
Probably something to do with
```
Plack::Response->header('Expires' => 'Tue, 25 Dec 2018 07:28:00 GMT');
```
but I wouldn't know.

## Mojo::Headers

Well, that was easy.  Just use
[Mojo::Headers](https://mojolicious.org/perldoc/Mojo/Headers#expires)
to set the ```Expires``` header.

But, wait!  That sets it for the page which isn't fat at all.
You only want to stop the javascript files from reloading every single time
and killing your mobile audience.

## ```defer``` and ```async```

tell your script to load after the main page
with
```
%= script defer 
TODO check syntax
```

## but it needs to load **FIRST**!

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
