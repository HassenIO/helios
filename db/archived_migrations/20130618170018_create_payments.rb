class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :amount
      t.references :rent
      t.integer :contribution_id
      t.text :contribution_details
    end
  end
end
