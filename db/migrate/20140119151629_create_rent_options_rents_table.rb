class CreateRentOptionsRentsTable < ActiveRecord::Migration
  def up
  	create_table :rent_options_rents, id: false do |t|
  	  t.references :rent_option
  	  t.references :rent
  	end
  	add_index :rent_options_rents, [:rent_option_id, :rent_id]
  end

  def down
  	drop_table :rent_options_rents
  end
end
