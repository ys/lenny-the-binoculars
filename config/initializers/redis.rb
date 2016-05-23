require "redis"

REPOSITORIES_KEY = "#{Rails.env}.lenny.repositories".freeze

REDIS = Redis.new
