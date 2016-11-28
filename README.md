
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