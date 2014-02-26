class AddTransmissionFieldToCars < ActiveRecord::Migration
  def change
    add_column :cars, :transmission, :string
  end
end
