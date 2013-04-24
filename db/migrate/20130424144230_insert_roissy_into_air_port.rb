class InsertRoissyIntoAirPort < ActiveRecord::Migration
  def up
    AirPort.create name: "Charles de Gaulle", city: "Paris", country: "France"
  end

  def down
    AirPort.delete_all
  end
end
