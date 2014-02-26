class AddDetailsToCars < ActiveRecord::Migration
  def change
    add_column :cars, :km, :string
    add_column :cars, :license, :string
    add_column :cars, :year, :integer
    add_column :cars, :nbSeats, :integer
    add_column :cars, :hasGps, :boolean
    add_column :cars, :hasCarRadio, :boolean
    add_column :cars, :isSmoker, :boolean
    add_column :cars, :acceptedPets, :boolean
  end
end
