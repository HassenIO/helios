class Parking < ActiveRecord::Base

	attr_accessible :airport, :brand, :dropoff, :email, :model, :name, :phone, :pickup, :year, :nb_people, :comment, :price
	attr_accessor :dropoff_date, :dropoff_time, :pickup_date, :pickup_time

	validates_presence_of :airport, :brand, :dropoff, :email, :model, :name, :phone, :pickup, :year, :nb_people, :comment, :price

	before_create :calculate_price

	def self.airports
		[["Sélectionner un aéroport", ""], ["Roissy Charles de Gaulle", "CDG"]]
	end

	def get_price
		nb_days = (self.pickup.to_date - self.dropoff.to_date).to_i

		return 40 if nb_days <= 4
		daily_price = 8 if nb_days >= 5 && nb_days <= 15
		daily_price = 6 if nb_days >= 16 && nb_days <= 31
		daily_price = 5 if nb_days >= 32

		return daily_price * nb_days
	end



	private

	def calculate_price
		self.price = self.get_price
	end

end
