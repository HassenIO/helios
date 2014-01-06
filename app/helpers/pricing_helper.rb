module PricingHelper

	def price_for_rent(rent, options = {})
		 price_for_rent_in_cents(rent, options)/100
	end

	def price_for_rent_in_cents(rent, options = {})
		# price = rent.try(:travel).try(:car).try(:category).try(:price) || options[:price] || 0
		# price = options[:price] || rent.try(:travel).try(:car).try(:category).try(:price) || 0
		price = options[:price] || options[:category].price || rent.try(:travel).try(:car).try(:category).try(:price) || 0
		price*reduc(rent, options[:category])*number_of_days(rent)
	end

	def number_of_days(rent)
		((rent.endDate - rent.startDate)/1.day).ceil
	end

	def reduc(rent, cat)
		r = 1
		days = number_of_days rent
		cat = cat.try(:name) || ""

		case cat
		when /2 Portes/
			r = 0.675 if days == 2
			r = 0.525 if (days == 3 || days == 4)
			r = 0.450 if (days >= 5 && days < 10)
			r = 0.425 if days >= 10
		when /Économique 5p/
			r = 0.545 if days == 2
			r = 0.436 if (days == 3 || days == 4)
			r = 0.418 if (days >= 5 && days < 10)
			r = 0.345 if days >= 10
		when /Compacte/
			r = 0.617 if days == 2
			r = 0.517 if (days == 3 || days == 4)
			r = 0.467 if (days >= 5 && days < 10)
			r = 0.333 if days >= 10
		when /Familiale/
			r = 0.692 if days == 2
			r = 0.600 if (days == 3 || days == 4)
			r = 0.538 if (days >= 5 && days < 10)
			r = 0.385 if days >= 10
		when /Grande routiére/
			r = 0.529 if days == 2
			r = 0.494 if (days == 3 || days == 4)
			r = 0.459 if (days >= 5 && days < 10)
			r = 0.318 if days >= 10
		end

		r *= 0.8 if cat =~ /old/
		r *= 1.2 if cat =~ /premium/

		return r
	end

end