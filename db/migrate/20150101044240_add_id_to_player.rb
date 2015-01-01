class AddIdToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :summonerId, :integer
  end
end
