class UpdateFuelInLowerCaseFromCars < ActiveRecord::Migration
  def up
    Car.all.each do |car|
      unless car.fuel.blank?
        car.update_attributes!(:fuel => car.fuel.downcase)
      end
    end

  end

  def down
  end
end
