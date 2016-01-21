Raven.configure do |config|
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  config.dsn = 'https://f29cfb8f265d4427ba9b341c99be4d70:bcc4165f99344ba09dc54588324b7447@app.getsentry.com/64564'
  config.environments = ['staging', 'production']
end
