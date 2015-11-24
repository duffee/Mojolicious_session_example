# Setting up a Mojolicious application

At the command line, type
```
mojo generate app GettingStarted
```
This will create the directory mytool and auto-generate a set of files which
we'll start from.

## Running Mojolicious

```
cd getting_started
morbo script/getting_started
```

open your browser at 
[localhost:3000](http://localhost:3000) 
and see the Welcome page.

## Testing the application

We will include test files to verify the application works as described
in the **t/** directory.  You can run any test with
```
prove -Ilib t/filename
```
The **-Ilib** adds the application library directory to your path and **prove**
runs the test harness.  To verify that Mojolicious has successfully 
started up (other than using a browser), run
```
prove -Ilib t/basic.t
```
which checks the welcome page and the perldoc pages are there.

To run the whole test suite, use the app with the test option like so
```
script/getting_started test
```

## Documentation

Mojolicious ships with all its documention available through the browser
when morbo is running.  
Use 
[localhost:3000/perldoc](http://localhost:3000/perldoc "Mojolicious Guides") 
to access the Guide.

To access the online help for the mojo command, use
```
mojo --help
```

# Next Step

Having created the framework for your app, the next step is
to create a login page following the instructions in [Login](Login.md)

These instructions don't assume that you've followed all the preceding
instructions, so remember to kill the server with Control-C before moving
on to the next step and starting a new server.
