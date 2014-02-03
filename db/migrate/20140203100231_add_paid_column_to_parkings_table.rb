class AddPaidColumnToParkingsTable < ActiveRecord::Migration
  def change
  	add_column :parkings, :status, :string, default: "pending"
  end
end
