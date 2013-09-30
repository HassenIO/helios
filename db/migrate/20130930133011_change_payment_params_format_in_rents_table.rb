class ChangePaymentParamsFormatInRentsTable < ActiveRecord::Migration
	def up
		change_column :rents, :payment_params, :text
	end

	def down
		change_column :rents, :payment_params, :string
	end
end
