class AddOptionsToCars < ActiveRecord::Migration
  def change
    add_column :cars, :desc, :string
    add_column :cars, :hasChildSeat, :boolean
    add_column :cars, :hasAirConditioning, :boolean
    add_column :cars, :fuel, :string
  end
end
