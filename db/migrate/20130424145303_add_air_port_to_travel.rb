class AddAirPortToTravel < ActiveRecord::Migration
  def change
    change_table Travel do |t|
      t.references :airPort
    end

  end
end
