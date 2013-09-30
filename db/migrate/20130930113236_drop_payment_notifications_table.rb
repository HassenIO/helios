class DropPaymentNotificationsTable < ActiveRecord::Migration
	def up
		drop_table :payment_notifications
	end

	def down
		raise ActiveRecord::IrreversibleMigration
	end
end
