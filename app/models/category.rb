class Category < ActiveRecord::Base
	
	attr_accessible :name, :price

	def price_in_euros
		self.price/100
	end

end
