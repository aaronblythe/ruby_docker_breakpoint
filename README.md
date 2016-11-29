

Simple Project to show how to set break points in Visual Studio Code when running a Sinatra app in a Docker Container.

# Usage

I have tested this with Docker for Mac 1.12.3 Stable.

Run:

    #Clone the repository
    git clone https://github.com/aaronblythe/ruby_docker_breakpoint.git
    cd ruby_docker_breakpoint
    # Open Visual Studio Code
    code .

Build the docker docker container and run it

    docker-compose build
    # I am not sure why running bundle install here is necessary, but with out it docker-compose up will fail with:
    # hellorubyvscode_1  | bundler: command not found: rdebug-ide
    # hellorubyvscode_1  | Install missing gem executables with `bundle install`
    # rubydockerbreakpoint_hellorubyvscode_1 exited with code 127
    docker-compose run hellorubyvscode bundle install
    docker-compose up

At this point you should see something like:

    ➜  ruby_docker_breakpoint git:(master) ✗ docker-compose up
    Recreating rubydockerbreakpoint_hellorubyvscode_1
    Attaching to rubydockerbreakpoint_hellorubyvscode_1
    hellorubyvscode_1  | Fast Debugger (ruby-debug-ide 0.6.0, debase 0.2.1, file filtering is supported) listens on 0.0.0.0:1234

It will wait here until you Navigate the to Debug View in Visual Studio Code and click the Play button on "Attach to Docker".  After it attaches then you should see:

    hellorubyvscode_1  | [2016-11-29 21:15:46] INFO  WEBrick 1.3.1
    hellorubyvscode_1  | [2016-11-29 21:15:46] INFO  ruby 2.1.10 (2016-04-01) [x86_64-linux]
    hellorubyvscode_1  | [2016-11-29 21:15:46] INFO  WEBrick::HTTPServer#start: pid=1 port=4567

From here set a breakpoint in the code in myapp.rb.  Then navigate to http://0.0.0.0:4567

You should now hit the breakpoint and be able to step over or step into or play.

## References

This project was an attempt to recreate the awesome work of Alexander Zeiter for debugging a Node application in a docker container using Visual Studio Code:

https://alexanderzeitler.com/articles/debugging-a-nodejs-es6-application-in-a-docker-container-using-visual-studio-code/

but for Ruby.

Also helpful (setup for RubyMine): http://bzzt.io/posts/running-the-rails-debugger-in-a-docker-container-using-rubymine

Notes on how to do the VSCode setup: https://github.com/rubyide/vscode-ruby/wiki/3.-Attaching-to-a-debugger


# Dockerfile alone

I could not get the Dockerfile to work alone.  It would only work when using Docker Compose as shown above.

This was not working for the Dockerfile:

    CMD ["rdebug-ide", "--host", "127.0.0.1" , "--port", "1234", "--dispatcher-port", "26162", "./myapp.rb"]

To be able to access sinatra from outside container need to do this:

    CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "4568"]

then navigate to http://0.0.0.0/4568 in your browser

From:  http://stackoverflow.com/questions/30027248/running-ruby-sinatra-inside-a-docker-container-not-able-to-connect-via-mac-host




Had to move from the Ruby 2.3 Docker container back to the Ruby 2.2 to make progress.

Getting on the docker container and running:

    docker stop hellorubyvscode
    docker rm hellorubyvscode
    docker build -t hellorubyvscode .
    docker run -d -p 1234:1234 -p 4567:4567 -p 26162:26162 -p 4568:4568 --name=hellorubyvscode hellorubyvscode
    docker exec -it hellorubyvscode bash

Once inside the docker container run (NOTE this should eventually be moved into the CMD above.)

    bundle exec rdebug-ide --host 0.0.0.0 --port 1234 --dispatcher-port 26162 -- bin/rackup --host 0.0.0.0 -p 4567
    bundle exec rdebug-ide --host 0.0.0.0 --port 1234 -- bin/rackup --host 0.0.0.0 -p 4567


Then it will only show: 

    Fast Debugger (ruby-debug-ide 0.6.0, debase 0.2.1, file filtering is supported) listens on 0.0.0.0:1234

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

