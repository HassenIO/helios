class ChangePaymentParamsFormatInRentsTable < ActiveRecord::Migration
	def up
		change_column :rents, :payment_params, :text
	end

	def down		
	end
end
