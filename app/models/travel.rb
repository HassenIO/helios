class TravelPeriodValidator < ActiveModel::Validator

	def validate(record)

		unless record.departure.blank?
			unless record.departure > Date.today
				record.errors.add(:departure, :cannot_be_past)
				record.errors.add(:departure_date, :cannot_be_past)
				record.errors.add(:departure_time, :cannot_be_past)
			end
		end

		unless record.arrival.blank?
			unless  record.arrival > Date.today
				record.errors.add(:arrival, :cannot_be_past)
				record.errors.add(:arrival_date, :cannot_be_past)
				record.errors.add(:arrival_time, :cannot_be_past)
			end
		end

		unless record.arrival.blank? || record.departure.blank?
			unless record.departure < record.arrival
				record.errors.add(:arrival, :cannot_be_before_departure)
				record.errors.add(:arrival_date, :cannot_be_before_departure)
				record.errors.add(:arrival_time, :cannot_be_before_departure)
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

	attr_accessible :arrival, :arrival_time, :arrival_date, :departure, :departure_date, :departure_time,
					:car_attributes, :airPort_id, :status, :has_accepted_cgv, :user_id, :commercial_text,
					:flight_n_departure, :flight_n_arrival, :count_person

	# add the accessors for the two fields
	attr_accessor :departure_date, :departure_time, :arrival_time, :arrival_date

	accepts_nested_attributes_for :car


	validates :airPort, :presence => true
	validates :arrival, :presence => true
	validates :departure, :presence => true
	validates :contacted, inclusion: { in: %w(YES NO) }
	validates_associated :car
	validates_with TravelPeriodValidator

	# add some callbacks
	after_initialize :get_datetimes # convert db format to accessors
	before_validation :set_datetimes # convert accessors back to db format
	before_validation :set_default_contacted
	before_save :set_datetimes # convert accessors back to db format
	before_create :set_default_rdv

	def status
		STATUS.key(read_attribute(:status))
	end

	def status=(s)
		write_attribute(:status, STATUS[s.to_sym])
	end

	def get_datetimes
		self.departure ||= Time.now + 2.days # if the startDate time is not set, set it to now

		self.departure_date ||= self.departure.to_date.to_s(:db) # extract the date is yyyy-mm-dd format
		self.departure_time ||= "#{'%02d' % self.departure.hour}:#{'%02d' % self.departure.min}" # extract the time

		self.arrival ||= Time.now + 9.days # if the endDate time is not set, set it to now

		self.arrival_date ||= self.arrival.to_date.to_s(:db) # extract the date is yyyy-mm-dd format
		self.arrival_time ||= "#{'%02d' % self.arrival.hour}:#{'%02d' % self.arrival.min}" # extract the time
	end

	def set_datetimes
		#do not change departure and arrival if already changed
		unless self.departure_changed? || self.arrival_changed?
			self.departure = "#{self.departure_date} #{self.departure_time}:00" # convert the two fields back to db
			self.arrival = "#{self.arrival_date} #{self.arrival_time}:00" # convert the two fields back to db
		end
	end

	def set_default_contacted
		self.contacted = "NO"
	end

	def set_default_rdv
		self.rdv = self.departure - 3.hours
	end

	# Check if the travel request has an image
	def has_image?
		!self.try(:car).try(:filepicker1_url).blank? || !self.try(:car).try(:filepicker2_url).blank? || !self.try(:car).try(:filepicker3_url).blank?
	end

end
