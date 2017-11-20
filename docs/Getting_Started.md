# Setting up a Mojolicious application

In this tutorial, each step builds on the previous step.
These instructions are written as if you are playing along at h
The completed app is a single example that resides in
the directory `session_tutorial` (which you will have already if you clone the 
[git repository](https://github.com/duffee/Mojolicious_session_example) 
along with other supporting material).
All the instructions given assume that you are starting
from scratch and tell you how to generate the final example
shown in `session_tutorial`.
If you want to start in the middle, have a look in the `Snapshots` directory of the repo.
More about that at the end of this page.

I assume that you're comfortable with running commands in Linux from a terminal window
and that you have [Mojolicious](http://mojolicious.org/) installed.

Let's get started.

## Getting Started

At the command line, type
```
mojo generate app SessionTutorial
```
This will create the directory `session_tutorial` and auto-generate a set of files which
we'll start from.

## Running Mojolicious

```
cd session_tutorial
morbo script/session_tutorial
```

open your browser at 
[localhost:3000](http://localhost:3000) 
and see the Welcome page.

`morbo` is one of the built-in webservers that ships with Mojolicious.  
It's portable and self-restart capable, making it perfect for development and testing.

## Testing the application

We will include test files to verify the application works as described
in the **t/** directory.
You can run any test with
```
prove -Ilib t/filename
```
The **prove** program runs the test harness and the **-Ilib** argument 
adds the application library directory to your path.
You will need to have 
[Test::Mojo](https://metacpan.org/pod/Test::Mojo) installed to run these tests.   

To verify that your Mojolicious will start up successfully (other than by using a browser), run
```
prove -Ilib t/basic.t
```
which checks the welcome page and the perldoc pages are there.

To run the whole test suite, use the app with the test option like so
```
script/session_tutorial test
```

## Documentation

Mojolicious ships with all its documention available through the browser
when morbo is running.  
Use 
[localhost:3000/perldoc](http://localhost:3000/perldoc "Mojolicious Guides") 
to access the Guide.

To access the command line help for the mojo command, use
```
mojo --help
```

# Next Step

Having created the framework for your app, the next step is
to create a login page following the instructions in [Login](Login.md)

I've taken a snapshot of the app as it is right now, 
which you can find in `Snapshots/Getting_Started`.
If at any time you want to go back to an earlier step,
simply stop the server, `cd` to the step in the `Snapshots` directory
and start the server there using `morbo script/session_tutorial`.
