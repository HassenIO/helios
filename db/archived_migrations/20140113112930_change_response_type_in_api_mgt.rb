class ChangeResponseTypeInApiMgt < ActiveRecord::Migration
	def up
		change_column :api_mgts, :response, :text
	end

	def down
		change_column :api_mgts, :response, :string
	end
end
