class AddLicenseToDrivers < ActiveRecord::Migration
  def change
    change_table :drivers do |t|
      t.string :license
    end
  end
end
