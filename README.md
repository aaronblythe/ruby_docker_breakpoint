
Attempting to recreate:

https://alexanderzeitler.com/articles/debugging-a-nodejs-es6-application-in-a-docker-container-using-visual-studio-code/

but for Ruby.

Also helpful (setup for RubyMine): http://bzzt.io/posts/running-the-rails-debugger-in-a-docker-container-using-rubymine

Notes on how to do the VSCode setup: https://github.com/rubyide/vscode-ruby/wiki/3.-Attaching-to-a-debugger

Run:

    docker build -t hellorubyvscode .
    docker run -d -p 1234:1234 -p 4567:4567 -p 26162:26162 hellorubyvscode


NOTES:

This was not working for the Dockerfile:

    CMD ["rdebug-ide", "--host", "127.0.0.1" , "--port", "1234", "--dispatcher-port", "26162", "./myapp.rb"]

To be able to access sinatra from outside container need to do this:

    CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "1234"]

From:  http://stackoverflow.com/questions/30027248/running-ruby-sinatra-inside-a-docker-container-not-able-to-connect-via-mac-host




Had to move from the Ruby 2.3 Docker container back to the Ruby 2.2 to make progress.

Getting on the docker container and running:

    docker stop hellorubyvscode
    docker rm hellorubyvscode
    docker build -t hellorubyvscode .
    docker run -d -p 1234:1234 -p 4567:4567 -p 26162:26162 -p 1235:1235 --name=hellorubyvscode hellorubyvscode
    docker exec -it hellorubyvscode bash

Once inside the docker container run (NOTE this should eventually be moved into the CMD above.)

    bundle exec rdebug-ide --host 0.0.0.0 --port 1235 --dispatcher-port 26162 -- bin/rackup --host 0.0.0.0 -p 4567

Then it will only show: 

    Fast Debugger (ruby-debug-ide 0.6.0, debase 0.2.1, file filtering is supported) listens on 0.0.0.0:1235

It is at this point you will need to come back to VS Code and click on the Play button for "Attach".  Then you will see:

    [2016-11-29 03:41:52] INFO  WEBrick 1.3.1
    [2016-11-29 03:41:52] INFO  ruby 2.2.6 (2016-11-15) [x86_64-linux]
    [2016-11-29 03:41:52] INFO  WEBrick::HTTPServer#start: pid=18 port=4567

Navigate to http://0.0.0.0:4567/ and it appears that the break point is being hit, however it is not showing up as being hit in VS Code.

When breakpoint is removed from code then it runs fine (shows "Hello World" in the browser.)

Use the disconnect button in VS Code to stop the debugging/application process in Docker.

Progress was made here, but may need to mount the actual drive?
Maybe need to step back to Ruby 2.1?
Maybe need to start using addressses other than 0.0.0.0?

