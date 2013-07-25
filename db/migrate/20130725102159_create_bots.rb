class CreateBots < ActiveRecord::Migration
  def change
    create_table :bots do |t|
      t.references "user"
      t.string :name
      t.string :uid
      t.string :provider
      t.text :info

      t.timestamps
    end
  end
end
