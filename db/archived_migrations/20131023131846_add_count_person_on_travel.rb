class AddCountPersonOnTravel < ActiveRecord::Migration
	def change
		add_column :travels, :count_person, :integer
	end
end
