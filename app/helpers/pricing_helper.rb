module PricingHelper

  def compute_price_for_rent(from, to, price)
    #ceil arrondi superieur
    nbjours = (to - from)/1.day.ceil
    number_to_currency(price*nbjours)
  end

end