class AddStatusFieldToPayments < ActiveRecord::Migration
  def change

    change_table Payment do |t|
      t.integer :status
    end

    Payment.update_all :status => 0

  end
end
