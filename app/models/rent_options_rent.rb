class RentOptionsRent < ActiveRecord::Base
	attr_accessible :rent_id, :rent_option_id

	belongs_to :rent
	belongs_to :rent_option
end
