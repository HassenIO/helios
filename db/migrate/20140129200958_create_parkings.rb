class CreateParkings < ActiveRecord::Migration
  def change
    create_table :parkings do |t|
      t.string :airport
      t.string :pickup
      t.string :dropoff
      t.string :name
      t.string :email
      t.string :phone
      t.string :brand
      t.string :model
      t.integer :year

      t.timestamps
    end
  end
end
