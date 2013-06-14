class AddLicenceDateToDrivers < ActiveRecord::Migration
  def change
    add_column :drivers, :license_year, :integer
  end
end
