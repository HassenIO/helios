class Car < ActiveRecord::Base
  attr_accessible :brand, :model

  validates :brand,  :presence => true
  validates :model,  :presence => true

  belongs_to  :users

end
