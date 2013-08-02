class User < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  def self.create_session_with_auth(auth)
    user = User.find_or_create_by(
      provider: auth["provider"],
      uid: auth["uid"]
    )
    user.name = auth["info"]["nickname"]
    user.save
    user.create_default_consumer
    user.id
  end

  def get_default_consumer_id
    BotConsumer.where(user_id: id, is_default: true).first.id
  end

  def create_default_consumer
    con = BotConsumer.new
    con.user_id = id
    con.provider = "twitter"
    con.name = "Bot-Manager"
    con.key = ENV["TWITTER_CONSUMER_KEY"]
    con.secret = ENV["TWITTER_CONSUMER_SECRET"]
    con.is_default = true
    con.save
  end

  private
  def create_params
    params.require(:user).permit(:provider,:uid)
  end

  has_many :bot
end
