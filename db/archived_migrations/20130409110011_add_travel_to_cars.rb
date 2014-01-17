class AddTravelToCars < ActiveRecord::Migration
  def change

    change_table :cars do |t|
      t.references :travel
    end

  end
end
