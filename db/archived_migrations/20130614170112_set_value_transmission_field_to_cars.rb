class SetValueTransmissionFieldToCars < ActiveRecord::Migration
  def up
    Car.all.each do |car|
      if car.transmission.blank?
        car.update_attribute :transmission, :manual
      end

      if car.fuel.blank?
        car.update_attribute :fuel, :essence
      else
        car.update_attribute :fuel, car.fuel.downcase
      end
    end

  end

  def down
  end
end
