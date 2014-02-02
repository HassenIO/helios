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

	before_save :adjust_params

	def self.airports
		[["Sélectionner un aéroport", ""], ["Roissy Charles de Gaulle", "CDG"], ["Paris Orly", "ORY"]]
	end

	def get_nb_days
		(self.pickup.to_date - self.dropoff.to_date).to_i + 1
	end

	def get_price
		nb_days = self.get_nb_days

		case self.airport
		when "CDG"
			return 40 if nb_days <= 4
			daily_price = 8 if nb_days >= 5 && nb_days <= 15
			daily_price = 6 if nb_days >= 16 && nb_days <= 31
			daily_price = 5 if nb_days >= 32
		when "ORY"
			daily_price = 10 if nb_days <= 4
			daily_price = 8 if nb_days >= 5 && nb_days <= 15
			daily_price = 7 if nb_days >= 16 && nb_days <= 31
			daily_price = 6 if nb_days >= 32
		end

		return daily_price * nb_days
	end

	def paypal_url redirect_url
		pp_params = {
		    business: ENV["PAYPAL_ACCOUNT"],
		    cmd: '_cart',
		    upload: 1,
		    return: redirect_url,
		    # notify_url: notify_url,
		    item_name_1: "Parking TravelerCar #{self.airport} #{self.get_nb_days} #{'jour'.pluralize self.get_nb_days}",
		    amount_1: self.price,
		    currency_code: "EUR"
		}
		ENV["PAYPAL_CHECKOUT"] + pp_params.to_query
	end



	private

	def adjust_params
		self.dropoff = Time.strptime self.dropoff, "%d/%m/%Y %H:%M"
		self.pickup = Time.strptime self.pickup, "%d/%m/%Y %H:%M"
		self.price = self.get_price
	end

end
