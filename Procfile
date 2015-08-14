redis: redis-server /usr/local/etc/redis.conf
web: bundle exec unicorn_rails -c ./config/unicorn.rb -l 5020
sub: bundle exec promiscuous subscribe
