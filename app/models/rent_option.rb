class RentOption < ActiveRecord::Base
	attr_accessible :code, :daily_price, :default_label, :price

	has_many :rent_options_rents
	has_many :rents, through: :rent_options_rents
end
