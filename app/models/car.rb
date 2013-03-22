class Car < ActiveRecord::Base
  attr_accessible :brand, :model

  belongs_to  :users
end
