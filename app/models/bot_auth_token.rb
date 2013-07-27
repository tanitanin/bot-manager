class BotAuthToken < ActiveRecord::Base
  belongs_to :bot
  belongs_to :bot_consumer

end
