class RentPeriodValidator < ActiveModel::Validator
  def validate(record)


    unless record.startDate.blank?
      unless record.startDate > Date.today
        record.errors.add(:startDate,:cannot_be_past)
      end
    end

    unless record.endDate.blank?
      unless record.endDate > Date.today
        record.errors.add(:endDate,:cannot_be_past)
      end
    end

    unless record.startDate.blank? or record.endDate.blank?
      unless record.startDate < record.endDate
        record.errors.add(:endDate,:cannot_be_before_start)
      end
    end
  end
end

class Rent < ActiveRecord::Base
  include ActiveModel::Validations

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

  validates_with RentPeriodValidator

  validates_associated :driver

  def self.valid_attribute?(attrib, value)
    mock = self.new(attrib => value)
    unless mock.valid?
      return !mock.errors.get(attrib).present?
    end
    true
  end

end
