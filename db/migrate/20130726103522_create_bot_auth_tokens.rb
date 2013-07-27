class CreateBotAuthTokens < ActiveRecord::Migration
  def change
    create_table :bot_auth_tokens do |t|

      t.references "bot"
      t.references "bot_consumer"
      t.string :token
      t.string :secret

      t.timestamps
    end
  end
end
