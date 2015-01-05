class AddTeamToGameStat < ActiveRecord::Migration
  def change
    add_column :game_stats, :team, :integer
  end
end
