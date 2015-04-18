require 'raven'

Raven.configure do |config|
  config.dsn = ENV=['SENTRY_KEY']
end
