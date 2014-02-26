class AddPicturesToCars < ActiveRecord::Migration
  def change
    add_column :cars, :filepicker1_url, :string
    add_column :cars, :filepicker2_url, :string
    add_column :cars, :filepicker3_url, :string
  end

end
