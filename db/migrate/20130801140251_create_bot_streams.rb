class CreateBotStreams < ActiveRecord::Migration
  def change
    create_table :bot_streams do |t|
      t.references "bot"
      t.string :type
      t.text :stream

      t.timestamps
    end
  end
end
