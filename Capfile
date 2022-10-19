
require "capistrano/setup"

require "capistrano/deploy"
require 'capistrano/rails'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'

require 'capistrano/puma'
install_plugin Capistrano::Puma  # Default puma tasks
install_plugin Capistrano::Puma::Systemd
install_plugin Capistrano::Puma::Monit, load_hooks: false  # Monit tasks without hooks
install_plugin Capistrano::Puma::Nginx  # upload a nginx site template


require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git


ENV['RAILS_MASTER_KEY'] = "<%= RAILS_MASTER_KEY %>"

Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
