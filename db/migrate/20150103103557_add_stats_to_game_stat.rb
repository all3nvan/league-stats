class AddStatsToGameStat < ActiveRecord::Migration
  def change
    add_column :game_stats, :kills, :float
    add_column :game_stats, :deaths, :float
    add_column :game_stats, :assists, :float
  end
end
