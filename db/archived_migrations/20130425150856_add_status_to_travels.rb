class AddStatusToTravels < ActiveRecord::Migration
  def change

    change_table Travel do |t|
      t.integer :status
    end

    Travel.update_all :status => 0
  end
end
