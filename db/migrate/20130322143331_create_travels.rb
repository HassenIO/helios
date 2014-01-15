class CreateTravels < ActiveRecord::Migration
  def change
    create_table :travels do |t|
      t.string :airPortName
      t.datetime :departure
      t.datetime :arrival

      t.timestamps
    end
  end
end
