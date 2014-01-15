class AddStatusToAirPorts < ActiveRecord::Migration
	def change

		add_column :air_ports, :status, :string, default: "ON"

	end
end
