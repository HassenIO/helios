class AddPriceToPrakingsTable < ActiveRecord::Migration
  def change
  	add_column :parkings, :price, :integer
  end
end
