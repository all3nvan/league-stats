class AddMoreStats3ToGameStat < ActiveRecord::Migration
  def change
    add_column :game_stats, :gold, :integer
    add_column :game_stats, :duration, :integer
  end
end
