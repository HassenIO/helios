class Travel < ActiveRecord::Base

  has_one :car
  belongs_to :user
  belongs_to :airPort

  attr_accessible :arrival, :departure, :car_attributes, :airPort_id

  accepts_nested_attributes_for :car


  validates :airPort, :presence => true
  validates :arrival, :presence => true
  validates :departure, :presence => true
  validates_associated :car



end
