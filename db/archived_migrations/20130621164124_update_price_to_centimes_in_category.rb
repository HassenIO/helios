class UpdatePriceToCentimesInCategory < ActiveRecord::Migration
  def up

    Category.all.each do |cat|
      unless cat.price.blank?
        cat.update_attributes!(:price => cat.price*100)
      end
    end
  end

  def down
  end
end
