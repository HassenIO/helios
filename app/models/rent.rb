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

	STATUS = [:unpaid, :paid, :canceled]

	attr_accessible :endDate, :endDate_time, :endDate_date, :startDate, :startDate_time, :startDate_date, :travel_id,
					:driver_attributes, :user_id, :airPort_id, :has_accepted_cgv, :comments,
					:status, :amount, :transaction_id, :payment_params

	attr_accessor :startDate_time, :startDate_date, :endDate_time, :endDate_date

	belongs_to :user

	has_one :driver, :dependent => :destroy
	has_one :payment

	belongs_to :travel
	belongs_to :airPort

	has_many :rent_options_rents
	has_many :rent_options, through: :rent_options_rents

	accepts_nested_attributes_for :driver

	validates :endDate, :presence => true
	validates :startDate, :presence => true

	validates :travel, :presence => true
	validates :user, :presence => true
	validates :airPort, :presence => true
	validates :status, inclusion: { in: STATUS }

	validates_with RentPeriodValidator

	validates_associated :driver

	after_initialize :get_datetimes
	before_validation :set_datetimes


	def self.valid_attribute?(attrib, value)
		mock = self.new(attrib => value)
		unless mock.valid?
			return !mock.errors.get(attrib).present?
		end
		true
	end

	def paypal_url redirect_url, notify_url
		pp_params = {business: ENV["PAYPAL_ACCOUNT"], cmd: '_cart', upload: 1, return: redirect_url, notify_url: notify_url, item_name_1: [self.travel.car.brand, self.travel.car.model].join(' - '), amount_1: amount, currency_code: "EUR"}
		ENV["PAYPAL_CHECKOUT"] + pp_params.to_query
	end

	def get_datetimes

		if startDate_date.nil? && startDate_time.nil?
			self.startDate ||= Time.now + 2.days
			self.startDate_date ||= self.startDate.to_date.to_s(:db)
			self.startDate_time ||= "#{'%02d' % self.startDate.hour}:#{'%02d' % self.startDate.min}"
			self.endDate ||= Time.now + 9.days
			self.endDate_date ||= self.endDate.to_date.to_s(:db)
			self.endDate_time ||= "#{'%02d' % self.endDate.hour}:#{'%02d' % self.endDate.min}"
		else
			self.set_datetimes
		end

	end

	def set_datetimes
		self.startDate = "#{self.startDate_date} #{self.startDate_time}:00"
		self.endDate = "#{self.endDate_date} #{self.endDate_time}:00"
	end

end
