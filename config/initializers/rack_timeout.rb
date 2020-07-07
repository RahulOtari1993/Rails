Rails.application.config.middleware.insert_before Rack::Runtime, Rack::Timeout, service_timeout: 90, wait_timeout: 90, wait_overtime: 90
