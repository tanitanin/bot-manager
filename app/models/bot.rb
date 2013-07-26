class Bot < ActiveRecord::Base

  def self.create_with_auth(auth)
    bot = Bot.new
    bot.provider = auth["provider"]
    bot.uid = auth["uid"]
    bot.name = auth["user_info"]["name"]
    bot.nickname = auth["user_info"]["nickname"]
    bot.token = auth['credentials']['token']
    bot.secret = auth['credentials']['secret']
    bot.save
  end

  def userstream
    puts "userstream..."
  end

  belongs_to :user
  has_many :daemon
end
