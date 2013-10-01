class AddAcceptedCgvToRents < ActiveRecord::Migration
  def change
    add_column :rents, :has_accepted_cgv, :boolean
  end
end
