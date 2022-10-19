
require_relative 'boot'
require 'rails/all'
# Include each railties manually, excluding `active_storage/engine`

#if ENV['DOCKER_LOGS']
#  fd = IO.sysopen("/proc/1/fd/1","w")
#  io = IO.new(fd,"w")
#  io.sync = true
#  MY_APPLICATION_LOG_OUTPUT = io
#else
#  MY_APPLICATION_LOG_OUTPUT = $stdout
#end


  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  #Bundler.require(:default, :assets, Rails.env)

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
#Bundler.require(:default, Rails.env) if defined?(Bundler)

module Credentials
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.require_master_key = true
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end

module Events
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.load_defaults 6.0
    config.require_master_key = true
    config.active_job.queue_adapter = :sidekiq # 使用 sidekiq 作为异步任务的适配器
    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Asia/Shanghai'
    config.active_record.default_timezone = :local
    config.active_record.time_zone_aware_attributes = false
    #config.active_record.default_timezone = :local
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.

    config.i18n.fallbacks = true
    config.encoding = "utf-8"
    config.i18n.default_locale = :"zh-CN"
    
    config.action_controller.perform_caching = true
    config.cache_store   = :redis_cache_store, { url: 'redis://localhost:6379/0'}
    config.session_store   :cache_store
    #config.session_store  :active_record_store

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
    
    config.assets.enabled = true
    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
    
    config.assets.initialize_on_precompile = false
    # Force ssl connection
    #config.force_ssl = true
    #config.ssl_options = { hsts: false }

    config.logger = Logger.new(STDOUT)
    config.log_level = :debug

  end
end
