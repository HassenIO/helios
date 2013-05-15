class AddAcceptedCgvToTravels < ActiveRecord::Migration
  def change
    add_column :travels, :has_accepted_cgv, :boolean
  end
end
