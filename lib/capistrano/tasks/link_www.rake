namespace :deploy do
  task :link_www do
    on roles(:app) do
      within release_path do
        execute :rm, '-f', '/var/www/current'
        execute :ln, '-s', release_path, '/var/www/current'
      end
    end
  end
end
