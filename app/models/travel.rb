class Travel < ActiveRecord::Base

  STATUS = { pending: 0, active: 1, rent: 2 }

  has_one :car
  belongs_to :user
  belongs_to :airPort

  attr_accessible :arrival, :departure, :car_attributes, :airPort_id, :status

  accepts_nested_attributes_for :car


  validates :airPort, :presence => true
  validates :arrival, :presence => true
  validates :departure, :presence => true
  validates_associated :car

  def status
    STATUS.key(read_attribute(:status))
  end

  def status=(s)
    write_attribute(:status, STATUS[s.to_sym])
  end

end
