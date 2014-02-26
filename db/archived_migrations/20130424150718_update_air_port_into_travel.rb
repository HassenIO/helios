class UpdateAirPortIntoTravel < ActiveRecord::Migration
  def up
       Travel.update_all :airPort_id => 1
  end

  def down

  end
end
