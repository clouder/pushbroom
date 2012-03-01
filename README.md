# Pushbroom

It helps keep your Gmail tidy. I have a live version up at
http://pushbroom.heroku.com.

## Set It Up

If you rather host one yourself, clone this sucker then:

Make the file config/app_env.rb with something like this:

    ENV['session_secret'] = 'some really long bullshit'
    ENV['consumer_key'] = 'anonymous'
    ENV['consumer_secret'] = 'anonymous'

You can use `rake secret` to get some really long bullshit. Using 'anonymous' will get you up and running, I'll leave it up to you to register your domain with Google and get specific credentials from them.

Last thing you need to do is setup a cron or scheduled task to run `rake pushbroom:full_sweep`.  Mine is setup to run once a day every morning.

## Heroku

If you are going to use Heroku, instead of using the config/app_env.rb you will just use the `heroku config:add` command.  It will look something like this `heroku config:add session_secret=someReallyLongBullshit consumer_key=anonymous consumer_secret=anonymous`. If you already pushed your clone up Heroku will tell you that your app is restarting and you should be good to go :)

Pushbroom used to use the cron addon from Heroku, but it appears as though they are getting rid of it.  They now have the Heroku Scheduler.  Add this through the dashboard on their web site.  Set the task to `rake pushbroom:full_sweep` then choose the time and interval at which you would like it to run.

## TODO

Have it run 2 or 3 Unicorn processes on one dyno so that on an initial delete of lots of emails doesn't keep other simpler requests waiting behind it.
