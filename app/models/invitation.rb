class Invitation < ActiveRecord::Base
	attr_accessible :code, :count, :desc, :status

	validates :code, presence: true, uniqueness: true
	validates :status, inclusion: { in: ['ON', 'OFF'] }

	scope :active_invitation, where( status: "ON" )
end
