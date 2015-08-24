redis: redis-server ./config/redis.conf
web: bundle exec unicorn_rails -c ./config/unicorn.rb -l 5020
sub: bundle exec promiscuous subscribe
