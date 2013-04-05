class Travel < ActiveRecord::Base

  attr_accessible :airPortName, :arrival, :departure,  :car_id

  validates :airPortName, :presence => true
  validates :arrival, :presence => true
  validates :departure, :presence => true

  belongs_to :user
  has_one :car

  accepts_nested_attributes_for :car
end
