class CreateDaemons < ActiveRecord::Migration
  def change
    create_table :daemons do |t|
      t.references "bot", null: false
      t.string :command
      t.string :proc_name
      t.text :proc_args
      t.integer :pid, null: false

      t.timestamps
    end
  end
end
