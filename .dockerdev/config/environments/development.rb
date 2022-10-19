Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb
  config.load_defaults 6.0
  config.active_job.queue_adapter = :sidekiq
  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false
  config.time_zone = 'Asia/Shanghai'
  config.active_record.default_timezone = :local
  config.active_record.time_zone_aware_attributes = false
  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  # Action controller caching
  config.action_controller.perform_caching = true
  config.cache_store  =  :redis_cache_store, { url: 'redis://localhost:6379/0'}

  #config.action_view.debug_rjs             = true

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true
  host = 'https://events.pylontqx.com:5443'
  #host = 'http://localhost:3003'
  config.action_mailer.delivery_method = :smtp 
  config.action_mailer.default_url_options = { host: host }

  # SMTP settings for gmail
  config.action_mailer.smtp_settings = {
    :address              => "smtp.189.cn",
    :port                 => 25,
    :user_name            => 'albert_ludake@189.cn',
    :password             => ${SMTP_PASSWORD},
    :authentication       => "login",
    :enable_starttls_auto => true
  }
  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  
  # Raise exception on mass assignment protection for Active Record models
  #config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  #config.active_record.auto_explain_threshold_in_seconds = 0.5

  config.log_tags = [:uuid, :remote_ip]
  
  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = false
  
  #config.serve_static_assets = false
 
  #config.logger = Logger.new(MY_APPLICATION_LOG_OUTPUT)

  config.logger = Logger.new(STDOUT)
  config.logger.level = Logger.const_get('DEBUG')

#  view rawdevelopment.rb
  config.eager_load = true
  #config.force_ssl = true
  #config.ssl_options = { hsts: false }
  config.active_storage.service = :local
  config.hosts << "events.pylontqx.com"
 # config.action_controller.asset_host = "http://pylontqi.mynetgear.com"
 # config.action_mailer.asset_host = "http://pylontqi.mynetgear.com"
end

