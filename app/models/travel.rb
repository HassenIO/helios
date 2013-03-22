class Travel < ActiveRecord::Base
  attr_accessible :airPortName, :arrival, :departure

  validates :airPortName,  :presence => true
  validates :arrival,  :presence => true
  validates :departure,  :presence => true

  belongs_to :user
end
