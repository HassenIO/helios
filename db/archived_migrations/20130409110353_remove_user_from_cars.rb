class RemoveUserFromCars < ActiveRecord::Migration

  def up
    remove_column :cars, :user_id
  end

  def down
    change_table :cars do |t|
      t.references :user
    end
  end

end
