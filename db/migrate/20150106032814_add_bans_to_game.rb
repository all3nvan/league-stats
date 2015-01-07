class AddBansToGame < ActiveRecord::Migration
  def change
    add_column :games, :blue_1, :integer
    add_column :games, :blue_2, :integer
    add_column :games, :blue_3, :integer
    add_column :games, :purple_1, :integer
    add_column :games, :purple_2, :integer
    add_column :games, :purple_3, :integer
  end
end
