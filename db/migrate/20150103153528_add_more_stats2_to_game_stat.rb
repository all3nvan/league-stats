class AddMoreStats2ToGameStat < ActiveRecord::Migration
  def change
    add_column :game_stats, :wards_placed, :integer
    add_column :game_stats, :pinks, :integer
    add_column :game_stats, :cs, :integer
  end
end
