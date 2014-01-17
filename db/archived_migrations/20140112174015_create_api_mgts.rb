class CreateApiMgts < ActiveRecord::Migration
  def change
    create_table :api_mgts do |t|
      t.string :pickup_date
      t.string :pickup_time
      t.string :dropoff_date
      t.string :dropoff_time
      t.integer :airport_id
      t.integer :driver_age
      t.string :affiliate_id
      t.integer :nb_travels
      t.integer :nb_days
      t.integer :min_price
      t.integer :max_price
      t.string :response
      t.string :token
      t.boolean :click, default: false
      t.integer :nb_clicks, default: 0
      t.string :travels

      t.timestamps
    end
  end
end
