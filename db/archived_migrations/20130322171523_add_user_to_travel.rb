class AddUserToTravel < ActiveRecord::Migration
  def change

    change_table :travels do |t|
      t.references :user
    end

  end
end
