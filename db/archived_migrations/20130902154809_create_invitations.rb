class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :code
      t.string :desc
      t.integer :count, default: 0
      t.string :status, default: "ON"

      t.timestamps
    end

    add_index :invitations, :code, unique: true
  end
end
