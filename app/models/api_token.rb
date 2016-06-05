# Api token stored in Redis
class ApiToken
  include ActiveModel::Model
  attr_accessor :raw_token

  TOKENS_KEY = "#{Rails.env}.lenny.api_tokens".freeze

  def self.valid?(token)
    REDIS.sismember(TOKENS_KEY, token)
  end

  def self.create
    token = SecureRandom.hex
    REDIS.sadd(TOKENS_KEY, token)
    new(raw_token: token)
  end

  def self.all
    REDIS.smembers(TOKENS_KEY).map do |t|
      new(raw_token: t)
    end
  end

  def to_s
    raw_token
  end

  def masked
    "****************************" + raw_token[-5..-1]
  end
end
