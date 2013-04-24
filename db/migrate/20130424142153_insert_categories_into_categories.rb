class InsertCategoriesIntoCategories < ActiveRecord::Migration
  def up
    Category.create :name => "Citadine", :price => 20
    Category.create :name => "Berline", :price => 30
    Category.create :name => "Monospace", :price => 45
    Category.create :name => "Haut de gamme", :price => 60
  end

  def down
    Category.delete_all
  end
end
