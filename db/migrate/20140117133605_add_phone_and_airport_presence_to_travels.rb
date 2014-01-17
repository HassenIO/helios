class AddPhoneAndAirportPresenceToTravels < ActiveRecord::Migration
  def change
  	add_column :travels, :phone, :string
  	add_column :travels, :presence, :integer
  end
end
