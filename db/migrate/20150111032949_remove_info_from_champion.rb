class RemoveInfoFromChampion < ActiveRecord::Migration
  def change
  	remove_column :champions, :wins
  	remove_column :champions, :losses
  	remove_column :champions, :picks
  	remove_column :champions, :bans
  end
end
