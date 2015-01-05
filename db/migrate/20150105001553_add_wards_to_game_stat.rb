class AddWardsToGameStat < ActiveRecord::Migration
  def change
    add_column :game_stats, :greens, :integer
  end
end
