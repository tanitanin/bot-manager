Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter,
    ENV["TWITTER_CONSUMER_KEY"],
    ENV["TWITTER_CONSUMER_SECRET"]
  #provider :facebook,"App ID","App Secret"
  #provider :mixi, 'consumer_key', 'consumer_secret'
end
