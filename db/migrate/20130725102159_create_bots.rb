class CreateBots < ActiveRecord::Migration
  def change
    create_table :bots do |t|
      t.references "user", null: false
      t.references "bot_auth_token"
      t.string :uid, null: false
      t.string :provider, null: false
      t.string :name
      t.string :nickname

      t.timestamps
    end
  end
end
