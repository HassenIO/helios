class AddCommentsFieldToRents < ActiveRecord::Migration
  def change
    add_column :rents, :comments, :text
  end
end
