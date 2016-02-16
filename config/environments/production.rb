Myflix::Application.configure do

  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_assets = false

  config.assets.compress = true
  config.assets.js_compressor = :uglifier

  config.assets.compile = false

  config.assets.digest = true

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify

  config.action_mailer.default_url_options = { :host => 'myflix.codefish.org' }

  config.action_mailer.smtp_settings = {
    address:              ENV.fetch('MAILGUN_SMTP_SERVER'),
    port:                 ENV.fetch('MAILGUN_SMTP_PORT'),
    user_name:            ENV.fetch('MAILGUN_SMTP_LOGIN'),
    password:             ENV.fetch('MAILGUN_SMTP_PASSWORD'),
    domain:               'cf-myflix.herokuapp.com',
    authentication:       :plain
  }
  config.action_mailer.delivery_method = :smtp
end

CarrierWave.configure do |config|
  config.storage    = :aws
  config.aws_bucket = ENV.fetch('AWS_S3_BUCKET_NAME')
  config.aws_acl    = 'public-read'

  # Optionally define an asset host for configurations that are fronted by a
  # content host, such as CloudFront.
  # config.asset_host = 'http://example.com'

  # The maximum period for authenticated_urls is only 7 days.
  config.aws_authenticated_url_expiration = 60 * 60 * 24 * 7

  # Set custom options such as cache control to leverage browser caching
  config.aws_attributes = {
    expires: 1.week.from_now.httpdate,
    cache_control: 'max-age=604800'
  }

  config.aws_credentials = {
    access_key_id:     ENV.fetch('AWS_ACCESS_KEY_ID'),
    secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
    region:            ENV.fetch('AWS_REGION') # Required
  }

  # Optional: Signing of download urls, e.g. for serving private
  # content through CloudFront.
  # config.aws_signer = -> (unsigned_url, options) { Aws::CF::Signer.sign_url unsigned_url, options }
end
