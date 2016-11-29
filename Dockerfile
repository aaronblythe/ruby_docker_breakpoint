FROM ruby:2.3

RUN apt-get update -qq && \
    apt-get install -qq -y nginx && \
    # temporay for debugging remove nano
    apt-get install -qq -y nano && \
    apt-get install -qq -y lsof && \
    # for netstat
    apt-get install -qq -y net-tools && \
    apt-get install -qq -y supervisor && \
    apt-get autoremove -y && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

EXPOSE 1234
EXPOSE 26162
EXPOSE 4567
COPY . /app
WORKDIR /app

RUN cd /app; bundle install --binstubs --path vendor/bundle
#CMD ["bundle", "exec", "rdebug-ide", "--host", "0.0.0.0" , "--port", "1234", "rackup"]
# This command allows access to sinatra from the host
CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "1234"]
#CMD ["bundle", "exec", "rdebug-ide", "--host", "0.0.0.0" , "--port", "1234", "--dispatcher-port", "26162", "--", "rackup", "-p", "4567"]
