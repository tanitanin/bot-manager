class BotController < ApplicationController

  def bot_auth_callback
    auth = request.env["omniauth.auth"]
    Bot.create_bot_with_auth(auth)
  end

end
