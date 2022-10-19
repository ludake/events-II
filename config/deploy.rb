# config valid for current version and patch releases of Capistrano
lock "~> 3.17.1"

user   = 'ludake'
domain = 'pylonTQx'

set :application, "events"
set :repo_url, "#{user}@#{domain}:/myraid10/git-repo/#{fetch(:application)}.git"
set :deploy_to, "/myraid10/var/www/#{fetch(:application)}"



role :web, domain                         
role :app, domain                         
role :db,  domain

set :stage, :production 
set :branch, 'master' 
set :rails_env, :production 


set :default_env, { path: "/usr/local/bin:/usr/bin:$PATH" }





# Default value for :format is :pretty
 set :format, :pretty

# Default value for :log_level is :debug
 set :log_level, :debug

# Default value for :pty is false
set :pty, true

set :linked_files, %w{config/master.key}

append :linked_files, "config/database.yml", "config/master.key", "config/credentials/production.key", \
			"config/credentials.yml.enc", "config/credentials/production.yml.enc", \
			"config/puma.rb"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/uploads", "public/uwrite", "public/system"



set :ssh_options,  { forward_agent: true, user: fetch(:user), auth_methods: ['publickey'], keys: %w(~/.ssh/authorized_keys) }

# Default value for keep_releases is 2
set :keep_releases, 2

# Don't change these unless you know what you're doing
set :puma_env, :production
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,   "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"  
set :puma_conf, "/myraid10/var/www/events/current/config/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_access.log"
set :puma_error_log, "#{shared_path}/log/puma_error.log"
set :puma_role, :app
set :puma_preload_app, false
set :puma_workers, 6

set :puma_init_active_record, false  # Change to false when not using ActiveRecord

set :pg_password, ENV['postgres_DATABASE_PASSWORD']
set :pg_ask_for_password, true

namespace :deploy do
  
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/#{fetch(:branch)}`
        puts "WARNING: HEAD is not the same as origin/#{fetch(:branch)}"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end
 
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  
  #Rake::Task['deploy:compile_assets'].clear
  #desc 'Compile assets'
  #task :compile_assets => [:set_rails_env] do
  #  unless fetch(:rails_env) == 'development-integration'
  #    invoke 'deploy:assets:precompile'
  #    invoke 'deploy:assets:backup_manifest'
  #  end
  #end  
  namespace :check do
    before :linked_files, :set_master_key do
      on roles(:app), in: :sequence, wait: 10 do
        unless  test("[ -f #{shared_path}/config/master.key ]") \
            && test("[ -f #{shared_path}/config/credentials/production.key ]") 
          unless test("[ -d #{shared_path}/config/credentials ]")
            execute  "mkdir -p #{shared_path}/config/credentials"
          end
          upload! 'config/master.key', "#{shared_path}/config/master.key"
          upload! 'config/credentials/production.key', "#{shared_path}/config/credentials/production.key"
        end
      end
    end
  end
  
  before :starting, :check_revision
  after :finishing, :compile_assets
  after :finishing, :cleanup
  after :finishing, :restart
  
  
end
