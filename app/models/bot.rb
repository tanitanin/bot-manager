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

  def get_default_consumer_and_token
    cons = BotConsumer.where(bot_id: id, is_default: true).first
    tok = BotAuthToken.where(bot_id: id, bot_consumer_id: cons.id).first
    {consumer: cons, token: tok}
  end

  def on_timeline_status(status)
    BotStream.add(:timeline,status)
  end

  def on_direct_message(direct_message)
    @client.update("D受け取った")
  end

  def on_favorite(event)
    source_user = event[:source]
    target_user = event[:target]
    status = event[:target_object]
    status_url = "https://twitter.com/"+status.user.screen_name
    status_url += "/status/"+status.id.to_s
    if target_user == @me then
      @client.update("#{source_user.name}さんにふぁぼられちゃった///")
    end
  end

  def on_unfavorite(event)
    source_user = event[:source]
    target_user = event[:target]
    status = event[:target_object]
    status_url = "https://twitter.com/"+status.user.screen_name
    status_url += "/status/"+status.id.to_s
    if target_user == @me then
      @client.update("#{source_user.name}さんにあんふぁぼされちゃった///")
    end
  end

  def on_follow(event)
    source_user = event[:source]
    target_user = event[:target]
  end

  def on_unfollow(event)
    #source_user = event[:source]
    target_user = event[:target]
  end

  def on_block(event)
    #source_user = event[:source]
    target_user = event[:target]
  end

  def on_unblock(event)
    #source_user = event[:source]
    target_user = event[:target]
  end

  def on_delete(status_id, user_id)
    @client.update("ツイ消しを見たよ")
  end
  def on_user_update(event)
    @me = @client.verify_credentials({:skip_status=>true})
  end

  def on_limit(skip_count)
    @client.update("規制くらった")
  end

  def on_reconnect(timeout,retries)
  end

  def on_error(message)
  end

  def userstream
    tmp = get_default_consumer_and_token
    consumer = tmp.consumer
    token = tmp.token

    # 自分のデータを取得
    @client = Twitter::Client.new
    @client.consumer_key = consumer.key
    @client.consumer_secret = consumer.secret
    @client.oauth_token = token.token
    @client.oauth_token_secret = token.secret
    @me = @client.verify_credentials({:skip_status=>true})

    # 以下marcov botからパクったまま
    # TODO: なおす
    @stream = TweetStream::Client.new
    @stream.auth_method = :oauth
    @stream.consumer_key = consumer.key
    @stream.consumer_secret = consumer.secret
    @stream.oauth_token = token.token
    @stream.oauth_token_secret = token.secret

    # それぞれの処理を登録
    @stream.on_timeline_status{|status| on_timeline_status(status)}
    @stream.on_direct_message{|direct_message| on_direct_message(direct_message)}
    @stream.on_event(:favorite){|event| on_favorite(event)}
    @stream.on_event(:unfavorite){|event| on_unfavorite(event)}
    @stream.on_event(:follow){|event| on_follow(event)}
    @stream.on_event(:unfollow){|event| on_unfollow(event)}
    @stream.on_event(:block){|event| on_block(event)}
    @stream.on_event(:unblock){|event| on_unblock(event)}
    @stream.on_delete{|status_id,user_id| on_delete(status_id, user_id)}
    @stream.on_limit{|skip_count| on_limit(skip_count)}
    @stream.on_reconnect{|timeout,retries| on_reconnect(timeout,retries)}
    @stream.on_error{|message| on_error(message)}

    # stream取得を開始
    @stream.userstream
  end

end
