require 'sidekiq/web'

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  username == ( ENV["SIDEKIQ_USERNAME"] || "admin" ) && password == ( ENV["SIDEKIQ_PASSWORD"] || "sidekiq" )
end
