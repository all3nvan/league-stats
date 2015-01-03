class AddPlayerIdToGameStat < ActiveRecord::Migration
  def change
    add_column :game_stats, :player_id, :integer
  end
end
