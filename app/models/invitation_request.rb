class InvitationRequest < ActiveRecord::Base
	attr_accessible :email, :status

	validates :email, presence: true, uniqueness: true
	validates :status, inclusion: { in: ['PENDING', 'SENT'] }
end
