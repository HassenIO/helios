class AddAirPortNameToRent < ActiveRecord::Migration
  def change
    change_table :rents do |t|
      t.string :airPortName

    end
  end
end
