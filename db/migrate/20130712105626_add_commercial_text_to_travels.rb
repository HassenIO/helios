class AddCommercialTextToTravels < ActiveRecord::Migration
  def change
    add_column :travels, :commercial_text, :text
  end
end
