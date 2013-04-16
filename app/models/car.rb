class Car < ActiveRecord::Base

  attr_accessible :brand, :model, :fuel, :nbSeats, :km, :year, :license , :desc
  attr_accessible :hasChildSeat, :hasGps, :hasCarRadio, :isSmoker, :acceptedPets, :hasAirConditioning
  attr_accessible :filepicker1_url, :filepicker2_url, :filepicker3_url

  validates :brand,  :presence => true
  validates :model,  :presence => true
  validates :year,  :presence => true
  validates :nbSeats,  :presence => true

  belongs_to :travels

end
