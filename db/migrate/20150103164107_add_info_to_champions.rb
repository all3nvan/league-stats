class AddInfoToChampions < ActiveRecord::Migration
  def change
    add_column :champions, :champ_id, :integer
    add_column :champions, :name, :string
  end
end
