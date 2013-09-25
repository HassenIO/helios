module PricingHelper

	def price_for_rent(rent, options = {})
		 price_for_rent_in_cents(rent, options)/100
	end

	def price_for_rent_in_cents(rent, options = {})
		#ceil arrondi superieur
		price = options[:price] || rent.try(:travel).try(:car).try(:category).try(:price) || 0

		price*number_of_days(rent)
	end

	def number_of_days(rent)
		((rent.endDate - rent.startDate)/1.day).ceil
	end

	def paypal_url price, item_name, redirect_url
		values = {
		    business: 'ibnbadis74-facilitator@yahoo.com',
		    cmd: '_cart',
		    upload: 1,
		    return: redirect_url,
		    item_name_1: item_name,
		    amount_1: price,
		    currency_code: 'EUR'
		}
		"https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
	end

end