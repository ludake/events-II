Rails.application.configure do
  
  #config/master.key , config/credentials.yml.enc , new in rails 5.2
  config.time_zone = 'Asia/Shanghai'
  config.active_record.default_timezone = :local
  config.active_record.time_zone_aware_attributes = false
  config.load_defaults 6.0  
  config.require_master_key = true
  config.active_job.queue_adapter = :sidekiq
  #config.secret_key_base = '<%= ENV["SECRET_KEY_BASE"] %>'
    
  # Settings specified here will take precedence over those in config/application.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true
   
  
  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.cache_store   = :redis_cache_store, { url: 'redis://localhost:6379/0'}
  config.active_storage.service = :local 
  # Specifies the header that your server uses for sending files
  #config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  #config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
   config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  #config.cache_store = :mem_cache_store, '0.0.0.0:11211'

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  
  #config.serve_static_assets = true
  config.assets.compile = true
  
  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.eager_load = true

  #config.force_ssl = true
  #config.ssl_options = { hsts: false }
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


end
