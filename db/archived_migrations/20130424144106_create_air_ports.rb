class CreateAirPorts < ActiveRecord::Migration
  def change
    create_table :air_ports do |t|
      t.string :name
      t.string :city
      t.string :country
    end
  end

end
