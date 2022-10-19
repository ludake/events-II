uri = "#{ENV['REDIS_URL']}" || 'redis://localhost:6379/0'

Rails.application.config.cache_store = :redis_store, { url: uri }
