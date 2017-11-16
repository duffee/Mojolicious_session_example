# HTTPS

Passwords sent in the clear are a bad idea.  How do we force our application
to use HTTPS?

## Why not use HTTPS everywhere?
That's a very good question and makes this step unnecessary.  Have a look
at the [Cookbook](http://localhost:3000/perldoc/Mojolicious/Guides/Cookbook#Basic-authentication1)
under Applications and a few other places for this
```
script/session_tutorial daemon -l 'https://*:3000?cert=./server.crt&key=./server.key'
```
or using morbo like in the other steps use
```
morbo -l 'https://*:3000?cert=./server.crt&key=./server.key' script/session_tutorial
```
To create the certificates, I was in the top level directory and issued this command
`openssl req -new -x509 -nodes -out server.crt -keyout server.key`


But if https everywhere makes your app run slow, continue.

## Mixed http/https usage
**Still not sure how this is done, but this might be a starting point**

` $c->req->url->base->scheme('https') `
or `$c->url_for()-> ... ->scheme('https')`


#### continue from here ####



# Try it out
Start the server with
```
morbo script/session_tutorial
```
and click through the Login link on [localhost:3000/](http://localhost:3000/)
to get to the [Login page](http://localhost:3000/login)

# Test the app

Make sure we can maintain sessions 

```
script/session_tutorial test 
```



# Next Step

Now that passwords are secure flying across the net, let's hook it up with
a real authentication source.  Instructions continue in [LDAP](LDAP.md).

## More information

How to create your own self-signed certificates
[Apache SSL FAQ](https://httpd.apache.org/docs/current/ssl/ssl_faq.html)
