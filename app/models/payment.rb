class Payment < ActiveRecord::Base

  before_create :default_values
  attr_accessible :amount, :contribution_details, :contribution_id, :status

  belongs_to :rent

  STATUS = {:unpaid => 0, :pending => 1, :paid => 2, :failed => 3}

  def status
    STATUS.key(read_attribute(:status))
  end

  def status=(s)
    write_attribute(:status, STATUS[s.to_sym])
  end

  def check_payment
    if self.status == :pending
      #contribution id save ?
      self.contribution_details = Leetchi::Contribution.details(self.contribution_id)
      #check status paiement
      self.status = self.contribution_details['IsSucceeded'] ? :paid : :failed
      self.save
    end
  end

  private
  def default_values
    self.status ||= :unpaid
  end

end
