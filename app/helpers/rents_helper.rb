module RentsHelper
	include ::PricingHelper

	def new_option option, nb_days
		daily_price = option.price.to_f / 100
		daily_price = (daily_price == daily_price.to_i) ? daily_price.to_i : daily_price.round(2)
		option_price = daily_price * (option.daily_price ? nb_days : 1)

		"<tr> <td class=\"option-label\"> <input style=\"margin-top:-4px\" type=\"checkbox\" name=\"options[#{option.code}]\" value=\"#{ option_price }\" class=\"rent-option-checkbox\"> #{option.default_label}<em style=\"color:#0090ff;font-size:0.7em\"> #{ daily_price } €#{" par jour" if option.daily_price}</em></td> <td class=\"option-price\" style=\"text-align:right\">-</td> </tr>".html_safe
	end

end
