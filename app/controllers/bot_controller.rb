class BotController < ApplicationController

  def twitter_bot_oauth
    # :oauth_callbackに認証後のコールバックURLを指定
    session[:consumer_id] = params[:consumer_id]
    session[:consumer_id] = 0 if session[:consumer_id] == nil
    consumer = BotConsumer.consumer(session[:consumer_id])
    request_token = consumer.get_request_token(
      { :oauth_callback => "http://#{request.env["HTTP_HOST"]}/bot/auth/callback" }
    )
    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret
    redirect_to request_token.authorize_url
    return
  end

  def twitter_bot_oauth_callback
    consumer = BotConsumer.consumer(session[:consumer_id])
    request_token = OAuth::RequestToken.new(
      consumer,
      session[:request_token],
      session[:request_token_secret]
    )
    access_token = request_token.get_access_token(
      {},
      :oauth_token => params[:oauth_token],
      :oauth_verifier => params[:oauth_verifier]
    )
    client = Twitter::Client.new(
      :consumer_key => consumer.key,
      :consumer_secret => consumer.secret,
      :oauth_token => access_token.token,
      :oauth_token_secret => access_token.secret
    )
    twitter_user = client.current_user(:skip_status => true)
    bot = Bot.where(uid: twitter_user.id).first
    if bot
      bot = Bot.create(
        user_id: current_user.id,
        provider: "twitter",
        uid: twitter_user.id,
        name: twitter_user.name,
        nickname: twitter_user.screen_name
      )
    end
    BotAuthToken.create(
      bot_id: bot.id,
      bot_consumer_id: session[:consumer_id],
      token: access_token.token,
      secret: access_token.secret
    )
    flash[:notice] = "Bot authentication succeeded"
    redirect_to :root
    return
  end

end
