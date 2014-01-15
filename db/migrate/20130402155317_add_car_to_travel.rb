class AddCarToTravel < ActiveRecord::Migration
  def change

    change_table :travels do |t|
      t.references :car
    end

  end
end
