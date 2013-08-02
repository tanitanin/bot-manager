class CreateBotConsumers < ActiveRecord::Migration
  def change
    create_table :bot_consumers do |t|

      t.references "user", null: false
      t.string :provider, null: false
      t.string :name, null: false
      t.string :key, null: false
      t.string :secret, null: false
      t.boolean :is_default, default: false

      t.timestamps
    end
  end
end
