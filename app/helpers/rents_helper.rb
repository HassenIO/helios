module RentsHelper
	include ::PricingHelper

	def new_option option, nb_days
		option_price = option.daily_price ? nb_days * option.price.to_f / 100 : option.price.to_f / 100

		"<tr> <td class=\"option-label\"> <input style=\"margin-top:-4px\" type=\"checkbox\" name=\"options[#{option.code}]\" value=\"#{ (option_price == option_price.to_i) ? option_price.to_i : option_price.round(2) }\" class=\"rent-option-checkbox\"> #{option.default_label}<span style=\"color:#0090ff;font-size:0.7em\"> (#{option.price.to_f / 100} € par jour)</span></td> <td class=\"option-price\" style=\"text-align:right\">-</td> </tr>".html_safe
	end

end
