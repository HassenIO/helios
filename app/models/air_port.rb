class AirPort < ActiveRecord::Base

	attr_accessible :city, :country, :name, :status

	validates :status, inclusion: { in: ["ON", "OFF"] }

end
