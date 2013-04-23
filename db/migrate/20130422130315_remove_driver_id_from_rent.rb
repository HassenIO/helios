class RemoveDriverIdFromRent < ActiveRecord::Migration
  def up
    remove_column :rents, :driver_id
  end

  def down
    add_column :rents, :driver_id, :integer
  end

end
