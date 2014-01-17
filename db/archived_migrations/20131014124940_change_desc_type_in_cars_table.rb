class ChangeDescTypeInCarsTable < ActiveRecord::Migration
	def up
		change_column :cars, :desc, :text
	end

	def down
		change_column :cars, :desc, :string
	end
end
