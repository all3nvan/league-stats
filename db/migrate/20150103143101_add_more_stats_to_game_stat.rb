class AddMoreStatsToGameStat < ActiveRecord::Migration
  def change
    add_column :game_stats, :win, :boolean
    add_column :game_stats, :champion, :integer
  end
end
