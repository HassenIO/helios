class TravelPeriodValidator < ActiveModel::Validator
  def validate(record)

    unless record.departure.blank?
      unless record.departure > Date.today
        record.errors.add(:departure, :cannot_be_past)
      end
    end

    unless record.arrival.blank?
      unless  record.arrival > Date.today
        record.errors.add(:arrival, :cannot_be_past)
      end
    end

    unless record.arrival.blank? || record.departure.blank?
      unless record.departure < record.arrival
        record.errors.add(:arrival, :cannot_be_before_departure)
      end
    end
  end
end


class Travel < ActiveRecord::Base
  include ActiveModel::Validations

  STATUS = {pending: 0, active: 1, rent: 2}

  has_one :car
  belongs_to :user
  belongs_to :airPort

  attr_accessible :arrival, :departure, :car_attributes, :airPort_id, :status

  accepts_nested_attributes_for :car


  validates :airPort, :presence => true
  validates :arrival, :presence => true
  validates :departure, :presence => true
  validates_associated :car
  validates_with TravelPeriodValidator

  def status
    STATUS.key(read_attribute(:status))
  end

  def status=(s)
    write_attribute(:status, STATUS[s.to_sym])
  end


end


