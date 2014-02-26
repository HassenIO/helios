class RemoveCarIdFromTravels < ActiveRecord::Migration

  def up
    remove_column :travels, :car_id
  end

  def down
    add_column :travels, :car_id, :integer
  end
end
