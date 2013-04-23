class Travel < ActiveRecord::Base

  has_one :car

  attr_accessible :airPortName, :arrival, :departure, :car_attributes

  accepts_nested_attributes_for :car


  validates :airPortName, :presence => true
  validates :arrival, :presence => true
  validates :departure, :presence => true
  validates_associated :car

  belongs_to :user

end
