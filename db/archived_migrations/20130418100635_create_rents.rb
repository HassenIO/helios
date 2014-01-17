class CreateRents < ActiveRecord::Migration
  def change
    create_table :rents do |t|
      t.datetime :startDate
      t.datetime :endDate
      t.references :user
      t.references :travel

      t.timestamps
    end
  end
end
