class AddDriverToRents < ActiveRecord::Migration
  def change
    change_table :rents do |t|
      t.references :driver
    end
  end
end
