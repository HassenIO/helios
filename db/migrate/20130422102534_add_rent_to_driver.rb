class AddRentToDriver < ActiveRecord::Migration
  def change
    change_table :drivers do |t|
      t.references :rent
    end
  end
end
