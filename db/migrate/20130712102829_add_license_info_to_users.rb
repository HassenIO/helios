class AddLicenseInfoToUsers < ActiveRecord::Migration
  def change

    add_column :users, :license_year, :integer
    add_column :users, :license, :string
    add_column :users, :birth_date, :date
  end
end
