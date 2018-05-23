# Authentication - A Slight Return

You've got a login page to stop the great unwashed from getting into your website,
but what about the Bad Person who tries to crack your passwords with a script?

Standard proceedure is to sleep on failure which doesn't bother a human,
but slows down a brute force attack.
The second step is to block access after a number of failed attempts,
usually for a timeout period.

## lib/SessionTutorial/Controller/Tutorial.pm
Add two new methods, **record_login_attempts** and **is_denied**
and plug them into the **on_user_login** method.

## Where do we render the Login Blocked page?
I've just added a render in the **on_user_login** method.
Is that good?

## Storing login attempts

I've gone for a simple hash just to illustrate the principle.
Are you worried about memory consumption?
How about `tie`ing the %Login_Attempts hash to a file stored on disk?
Perhaps you want to store a lot more information about logins,
say to ask the user if they recognize their last successful login?
It might be better to use a database (Mysql, Redis, Sqlite) to store 
the attempts and allow the administrator to access or reset the data.
Only limited by your imagination.

# Try it out
With the server running,
click through the Login link on [localhost:3000/](http://localhost:3000/)
to get to the [Login page](http://localhost:3000/login)

#### TODO ####

# Test the app

```
script/session_tutorial test t/01_login.t
```

# Next Step


## More information

