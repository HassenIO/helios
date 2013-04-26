class Rent < ActiveRecord::Base
  attr_accessible :endDate, :startDate, :travel_id, :driver_attributes, :user_id, :airPort_id


  belongs_to :user

  has_one :driver, :dependent => :destroy
  belongs_to :travel
  belongs_to :airPort

  accepts_nested_attributes_for :driver


  validates :endDate, :presence => true
  validates :startDate, :presence => true

  validates :travel, :presence => true
  validates :user, :presence => true
  validates :airPort, :presence => true

  validates_associated :driver

end