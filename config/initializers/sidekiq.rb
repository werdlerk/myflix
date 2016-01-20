require 'sidekiq'
require 'sidekiq/web'

Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  username == ( ENV["SIDEKIQ_USERNAME"] || "admin" ) && password == ( ENV["SIDEKIQ_PASSWORD"] || "sidekiq" )
end
