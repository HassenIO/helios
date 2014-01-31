class Parking < ActiveRecord::Base

	attr_accessible :airport, :brand, :dropoff, :email, :model, :name, :phone, :pickup, :year, :nb_people, :comment, :price

	validates :airport, presence: true
	validates :brand, presence: true
	validates :dropoff, presence: true
	validates :email, presence: true
	validates :model, presence: true
	validates :name, presence: true
	validates :phone, presence: true
	validates :pickup, presence: true
	validates :year, presence: true
	validates :nb_people, presence: true

	before_save :change_date_format
	before_save :calculate_price

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

	def change_date_format
		self.dropoff = Time.strptime self.dropoff, "%d/%m/%Y %H:%M"
		self.pickup = Time.strptime self.pickup, "%d/%m/%Y %H:%M"
	end

	def calculate_price
		self.price = self.get_price
	end

end
