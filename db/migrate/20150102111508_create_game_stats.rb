class CreateGameStats < ActiveRecord::Migration
  def change
    create_table :game_stats do |t|

      t.timestamps null: false
    end
  end
end
