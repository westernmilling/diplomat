server 'app01',
       user: 'deploy',
       port: 22,
       roles: %w{app db web}

set :web_servers,
    %w{web01 web02}
