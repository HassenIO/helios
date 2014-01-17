class CreateRentOptions < ActiveRecord::Migration
  def change
    create_table :rent_options do |t|
      t.string :code
      t.integer :price, default: 0
      t.boolean :daily_price, default: false
      t.string :default_label

      t.timestamps
    end

    add_index( :rent_options, [:code] , unique: true, limit: 64 )
  end
end
