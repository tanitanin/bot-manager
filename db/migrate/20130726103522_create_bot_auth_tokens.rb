class CreateBotAuthTokens < ActiveRecord::Migration
  def change
    create_table :bot_auth_tokens do |t|

      t.references "bot", null: false
      t.references "bot_consumer", null: false
      t.string :token, null: false
      t.string :secret, null: false

      t.timestamps
    end
  end
end
