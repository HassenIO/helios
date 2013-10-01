class AddColumnsToRentsTable < ActiveRecord::Migration
	def change
		add_column :rents, :status, :string, default: :unpaid
		add_column :rents, :transaction_id, :string
		add_column :rents, :payment_params, :string
		add_column :rents, :amount, :integer
	end
end
