class RentPeriodValidator < ActiveModel::Validator

	def validate(record)
		unless record.startDate.blank?
			unless record.startDate > Date.today
				record.errors.add(:startDate, :cannot_be_past)
				record.errors.add(:startDate_time, :cannot_be_past)
				record.errors.add(:startDate_date, :cannot_be_past)
			end
		end

		unless record.endDate.blank?
			unless record.endDate > Date.today
				record.errors.add(:endDate, :cannot_be_past)
				record.errors.add(:endDate_date, :cannot_be_past)
				record.errors.add(:endDate_time, :cannot_be_past)
			end
		end

		unless record.startDate.blank? or record.endDate.blank?
			unless record.startDate < record.endDate
				record.errors.add(:endDate, :cannot_be_before_start)
				record.errors.add(:endDate_date, :cannot_be_before_start)
				record.errors.add(:endDate_time, :cannot_be_before_start)
			end
		end
	end

end

class Rent < ActiveRecord::Base

	include ActiveModel::Validations

	attr_accessible :endDate, :endDate_time, :endDate_date, :startDate, :startDate_time, :startDate_date, :travel_id,
					:driver_attributes, :user_id, :airPort_id, :has_accepted_cgv, :comments

	# add the accessors for the two fields
	attr_accessor :startDate_time, :startDate_date, :endDate_time, :endDate_date


	belongs_to :user

	has_one :driver, :dependent => :destroy
	has_one :payment

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

	# add some callbacks
	after_initialize :get_datetimes # convert db format to accessors
	before_validation :set_datetimes # convert accessors back to db format

	def self.valid_attribute?(attrib, value)
		mock = self.new(attrib => value)
		unless mock.valid?
			return !mock.errors.get(attrib).present?
		end
		true
	end

	def get_datetimes

		if startDate_date.nil? && startDate_time.nil?
			self.startDate ||= Time.now + 2.days # if the startDate time is not set, set it to now

			self.startDate_date ||= self.startDate.to_date.to_s(:db) # extract the date is yyyy-mm-dd format
			self.startDate_time ||= "#{'%02d' % self.startDate.hour}:#{'%02d' % self.startDate.min}" # extract the time

			self.endDate ||= Time.now + 9.days # if the endDate time is not set, set it to now

			self.endDate_date ||= self.endDate.to_date.to_s(:db) # extract the date is yyyy-mm-dd format
			self.endDate_time ||= "#{'%02d' % self.endDate.hour}:#{'%02d' % self.endDate.min}" # extract the time
		else
			self.set_datetimes
		end

	end

	def set_datetimes
		self.startDate = "#{self.startDate_date} #{self.startDate_time}:00" # convert the two fields back to db
		self.endDate = "#{self.endDate_date} #{self.endDate_time}:00" # convert the two fields back to db
	end

end
