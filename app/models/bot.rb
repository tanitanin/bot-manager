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

  def on_timeline_status(status)
    logger.info("userstream on_timeline_status:#{status.id}")
    #BotStream.add(:timeline,status)
  end

  def on_direct_message(direct_message)
    logger.info("userstream on_direct_message")
    @client.update("D受け取った")
  end

  def on_favorite(event)
    logger.info("userstream on_favorite")
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
    logger.info("userstream on_unfavorite")
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
    logger.info("userstream on_follow")
    source_user = event[:source]
    target_user = event[:target]
  end

  def on_unfollow(event)
    logger.info("userstream on_unfollow")
    #source_user = event[:source]
    target_user = event[:target]
  end

  def on_block(event)
    logger.info("userstream on_block")
    #source_user = event[:source]
    target_user = event[:target]
  end

  def on_unblock(event)
    logger.info("userstream on_unblock")
    #source_user = event[:source]
    target_user = event[:target]
  end

  def on_delete(status_id, user_id)
    logger.info("userstream on_delete")
    @client.update("ツイ消しを見たよ")
  end

  def on_user_update(event)
    logger.info("userstream on_user_update")
    @me = @client.verify_credentials({:skip_status=>true})
  end

  def on_limit(skip_count)
    logger.info("userstream on_limit:#{skip_count}")
    @client.update("規制くらった")
  end

  def on_reconnect(timeout,retries)
    logger.info("userstream reconnect #{timeout} #{retries}")
  end

  def on_error(message)
    logger.error("userstream error:#{message}")
  end

  def userstream
    logger.info("Bot.userstream start")

    # get consumer and token
    consumer = BotConsumer.where(user_id: user_id, is_default: true).first
    logger.info("bot:#{id} get_default_consumer:#{consumer.id}")
    token = BotAuthToken.where(bot_id: id, bot_consumer_id: consumer.id).first
    logger.info("bot:#{id} get_default_token:#{token.id}")

    # 自分のデータを取得
    logger.info("Bot.userstream get bot data")
    @client = Twitter::Client.new
    @client.consumer_key = consumer.key
    @client.consumer_secret = consumer.secret
    @client.oauth_token = token.token
    @client.oauth_token_secret = token.secret
    logger.info("@client: consumer and token set")

    @me = @client.verify_credentials({:skip_status=>true})
    logger.info("Bot.userstream uid:#{@me.id} verify ok")

    # 以下marcov botからパクったまま
    @stream = TweetStream::Client.new
    @stream.auth_method = :oauth
    @stream.consumer_key = consumer.key
    @stream.consumer_secret = consumer.secret
    @stream.oauth_token = token.token
    @stream.oauth_token_secret = token.secret
    logger.info("Bot.userstream uid:#{@me.id} stream consumer and token set")

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
    logger.info("Bot.userstream uid:#{@me.id} stream setting complete")

    # stream取得を開始
    logger.info("Bot.userstream uid:#{@me.id} userstream run")
    @stream.userstream
    logger.info("Bot.userstream uid:#{@me.id} userstream ended")
  end

end
