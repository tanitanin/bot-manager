class Bot < ActiveRecord::Base
  belongs_to :user
  has_many :bot_auth_token
  has_many :daemon

  def self.create_with_auth(auth)
    bot = Bot.new
    bot.provider = auth["provider"]
    bot.uid = auth["uid"]
    bot.name = auth["user_info"]["name"]
    bot.nickname = auth["user_info"]["nickname"]
    bot.token = auth['credentials']['token']
    bot.secret = auth['credentials']['secret']
    bot.save
    return bot
  end

  def userstream
    puts "userstream..."
  end

end
