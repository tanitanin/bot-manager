class CreateBotConsumers < ActiveRecord::Migration
  def change
    create_table :bot_consumers do |t|

      t.references "user"
      t.string :provider
      t.string :name
      t.string :key
      t.string :secret

      t.timestamps
    end
  end
end
