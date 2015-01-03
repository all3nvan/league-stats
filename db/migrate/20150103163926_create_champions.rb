class CreateChampions < ActiveRecord::Migration
  def change
    create_table :champions do |t|
      t.integer :wins
      t.integer :losses
      t.integer :picks
      t.integer :bans

      t.timestamps null: false
    end
  end
end
