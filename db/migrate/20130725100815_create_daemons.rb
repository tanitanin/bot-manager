class CreateDaemons < ActiveRecord::Migration
  def change
    create_table :daemons do |t|
      t.references "bot"
      t.string :proc_name
      t.text :proc_args
      t.integer :pid

      t.timestamps
    end
  end
end
