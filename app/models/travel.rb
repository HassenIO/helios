class Travel < ActiveRecord::Base

  attr_accessible :airPortName, :arrival, :departure,:car_attributes

  validates :airPortName, :presence => true
  validates :arrival, :presence => true
  validates :departure, :presence => true

  has_one :car

  accepts_nested_attributes_for :car


end
