class Invitation < ActiveRecord::Base
	attr_accessible :code, :count, :desc, :status

	validates :code, presence: true, uniqueness: true
	validates :status, inclusion: { in: ['ON', 'OFF'] }

	scope :active_invitation, where( status: "ON" )



	# Check if an invitation code is valid and active.
	def self.get_invitation code
		return code ? Invitation.where(code: code, status: 'ON').first : nil
	end
end
