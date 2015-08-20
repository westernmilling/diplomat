lock '3.4.0'

set :branch, ''
set :deploy_to, '/var/www/diplomat'
set :keep_releases, 5
set :linked_files, %w{config/application.yml config/database.yml}
set :linked_dirs,
    %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :normalize_asset_timestamps,
    %w{public/images public/javascripts public/stylesheets}
set :repo_url, ''

namespace :deploy do
  after :publishing, :link_www
  after :publishing, :restart
  after :publishing, 'web:public'
end

before 'deploy:assets:precompile', 'deploy:assets:bower'
