class Rent < ActiveRecord::Base
  attr_accessible :endDate, :startDate, :airPortName, :travel_id, :driver_attributes, :user_id


  belongs_to :user

  has_one :driver, :dependent => :destroy
  belongs_to :travel

  accepts_nested_attributes_for :driver

  validates :airPortName, :presence => true
  validates :endDate, :presence => true
  validates :startDate, :presence => true

  validates :travel, :presence => true
  validates :user, :presence => true

  validates_associated :driver

end
