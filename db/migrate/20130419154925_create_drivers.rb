class CreateDrivers < ActiveRecord::Migration
  def change
    create_table :drivers do |t|
      t.string :first_name
      t.string :last_name
      t.string :address
      t.string :city
      t.string :country
      t.string :zip_code
      t.string :phone
      t.date :birth_date

      t.timestamps
    end
  end
end
