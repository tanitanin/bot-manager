class CreateBots < ActiveRecord::Migration
  def change
    create_table :bots do |t|
      t.references "user"
      t.references "bot_auth_token"
      t.string :uid
      t.string :provider
      t.string :name
      t.string :nickname
      t.string :token
      t.string :secret

      t.timestamps
    end
  end
end
