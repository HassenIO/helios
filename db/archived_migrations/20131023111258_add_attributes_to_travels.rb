class AddAttributesToTravels < ActiveRecord::Migration
	def change
		add_column :travels, :rdv, :datetime
		add_column :travels, :flight_n_departure, :string
		add_column :travels, :flight_n_arrival, :string
		add_column :travels, :contacted, :string
		add_column :travels, :reg_document, :string
	end
end
