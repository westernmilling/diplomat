namespace :deploy do
  namespace :assets do
    desc 'Install local bower and bower packages'
    task :bower do
      on roles(:web) do
        within release_path do
          execute :npm, :install, :bower, '--quiet'
          execute './node_modules/bower/bin/bower',
                  :install,
                  '--config.interactive=false'
        end
      end
    end
  end
end
