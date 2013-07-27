class BotConsumer < ActiveRecord::Base
  belongs_to :user
  has_many :bot_auth_token

  def self.consumer(id = 0)
    cm = BotConsumer.find(id)
    consumer_key = cm.key
    consumer_secret = cm.secret
    twitter_consumer(consumer_key,consumer_secret)
  end 

  def self.twitter_consumer(key,secret)
    OAuth::Consumer.new(
      key,
      secret,
      {
        :site => "http://api.twitter.com",
        :scheme => :header,
        :http_method => :post,
        :request_token_path => "/oauth/request_token",
        :access_token_path  => "/oauth/access_token",
        :authorize_path     => "/oauth/authorize"
      }
    )
  end
end
