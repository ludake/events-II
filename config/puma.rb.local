workers Integer(ENV['WEB_CONCURRENCY'] || 6)
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 16)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
#port        ENV['PORT']     || 3003
bind "tcp://0.0.0.0:#{ ENV.fetch("PORT") { 3003 } }"
environment ENV['RACK_ENV'] || 'production'

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end
