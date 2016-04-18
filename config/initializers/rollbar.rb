Rollbar.configure do |config|
  config.access_token = ENV["ROLLBAR_ACCESS_TOKEN"]
  config.enabled = ENV["ROLLBAR_ACCESS_TOKEN"].present? ? true : false
  config.use_sidekiq
  config.environment = ENV["ROLLBAR_ENV"] || Rails.env
end
