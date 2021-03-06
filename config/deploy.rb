set :application, 'infoip.ro'
set :repo_url, 'git@github.com:alexbumbacea/infoip.ro.git'
set :deploy_via, :remote_cache


# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/symfony.infoip.ro'

# Default value for keep_releases is 5
set :keep_releases, 5


# set :format, :pretty
set :log_level, :debug

set :use_set_permissions,   true
set :permission_method,     :chown
set :file_permissions_paths, ["var/logs","var/sessions", "var"]
set :file_permissions_users, ["apache"]
set :file_permissions_groups, ["apache"]
set :file_permissions_chmod_mode, "0777"
set :composer_dump_autoload_flags, ''
set :composer_install_flags, '--no-dev --no-interaction --quiet'




SSHKit.config.command_map[:composer] = "php #{shared_path.join("composer.phar")}"

after "deploy:starting", 'composer:install_executable'

namespace :nginx do
  task "start" do
    desc "Start NGINX"
    on roles(:app) do
      sudo "systemctl start nginx.service"
    end
  end
  task "stop" do
    desc "Stop NGINX"
    on roles(:app) do
      sudo "systemctl stop nginx.service"
    end
  end
  task "reload" do
    desc "Stop NGINX"
    on roles(:app) do
      sudo "systemctl reload nginx.service"
    end
  end
  task "restart" do
    desc "Stop NGINX"
    on roles(:app) do
      sudo "systemctl restart nginx.service"
    end
  end
end

after 'deploy:publishing', 'deploy:restart'
after "deploy:restart", "nginx:reload"


