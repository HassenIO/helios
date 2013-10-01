class CreateInvitationRequests < ActiveRecord::Migration
  def change
    create_table :invitation_requests do |t|
      t.string :email
      t.string :status, default: "PENDING"

      t.timestamps
    end

    add_index :invitation_requests, :email, unique: true
  end
end
