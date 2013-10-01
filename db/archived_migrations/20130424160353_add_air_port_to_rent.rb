class AddAirPortToRent < ActiveRecord::Migration
  def change
    change_table Rent do |t|
      t.references :airPort
    end

    Rent.update_all :airPort_id => 1

  end
end
