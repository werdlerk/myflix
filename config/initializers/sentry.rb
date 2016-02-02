Raven.configure do |config|
  config.silence_ready = true
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  config.dsn = ENV['SENTRY_DSN'] if ENV['SENTRY_DSN']
  config.environments = ['staging', 'production']
end
