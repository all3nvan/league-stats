class AddGameIdToGameStat < ActiveRecord::Migration
  def change
    add_column :game_stats, :game_id, :integer
  end
end
