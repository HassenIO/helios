class AddCategoryToCars < ActiveRecord::Migration
  def change

    change_table :cars do |t|
      t.references :category
    end

  end
end
