namespace :deploy do
  namespace :web do
    task :public do
      web_servers = fetch(:web_servers)
      web_servers.each do |web_server|
        puts "Deploying to web server: #{web_server}"

        run_locally do
          execute :ssh, "www@#{web_server}", "mkdir -p #{deploy_to}/"
          execute :rsync, "-av ./public www@#{web_server}:#{deploy_to}/"
        end
      end
    end
  end
end
