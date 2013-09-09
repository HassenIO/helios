class Driver < ActiveRecord::Base
	
	attr_accessible :address, :birth_date, :city, :country, :first_name, :last_name, :phone, :zip_code, :license, :license_year

	validates :address, :presence => true
	validates :birth_date, :presence => true
	validates :city, :presence => true
	validates :country, :presence => true
	validates :first_name, :presence => true
	validates :last_name, :presence => true
	validates :zip_code, :presence => true
	validates :license, :presence => true
	validates :license_year, :presence => true

	belongs_to :rent
	
end
