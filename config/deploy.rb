# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'infoip.ro'
set :repo_url, 'git@github.com:alexbumbacea/infoip.ro.git'
set :deploy_via, :remote_cache
server 'infoip.ro', roles: %w{app web db main primary}


# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/symfony.infoip.ro'

# Default value for :scm is :git
set :scm, :git

# Default value for keep_releases is 5
set :keep_releases, 5

set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names



after "deploy:restart", "deploy:cleanup"
before "deploy:restart", "deploy:changeowner"
namespace :deploy do
  task "changeowner" do
    sudo "chown -R www-data:www-data #{current_release}"
  end
end

namespace :nginx do
  task "start" do
    desc "Start NGINX"
    sudo "systemctl start nginx.service"
  end
  task "stop" do
    desc "Stop NGINX"
    sudo "systemctl stop nginx.service"
  end
  task "reload" do
    desc "Stop NGINX"
    sudo "systemctl reload nginx.service"
  end
  task "restart" do
    desc "Stop NGINX"
    sudo "systemctl restart nginx.service"
  end
  after "deploy:restart", "nginx:reload"
end
