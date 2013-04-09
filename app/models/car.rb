class Car < ActiveRecord::Base
  attr_accessible :brand, :model, :nbSeats, :km, :year, :license ,:hasGps, :hasCarRadio, :isSmoker, :acceptedPets

  validates :brand,  :presence => true
  validates :model,  :presence => true



  belongs_to :travels

end
