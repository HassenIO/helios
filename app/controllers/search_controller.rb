class SearchController < ApplicationController

	before_filter :authenticate_user!

	def index
		@rent = Rent.new
		# @rent.airPort = AirPort.find(1) # DON'T UNDERSTAND WHAT/WHY IS THIS???

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @rent }
		end
	end

	def search
		# check valid params

		@travels = []
		@rent = Rent.new(params[:rent])

		respond_to do |format|
			if !rent_partial_validation(@rent)
				@rent.valid?
				format.html # search.html.erb
				format.json { render json: @rent.errors, status: :unprocessable_entity }
			else
				@travels = Travel.where('arrival > :end AND departure < :start AND "airPort_id" = :airPort_id AND status = 1',
					{:start => @rent.startDate,
					 :end => @rent.endDate,
					 :airPort_id => @rent.airPort_id})

				format.html # search.html.erb
				format.json { render json: [@rent, @travels] }

			end
		end


	end

	private
	def rent_partial_validation(rent)
		#!Rent.valid_attribute?(:airPort_id, rent.airPort_id) or !Rent.valid_attribute?(:startDate, rent.startDate) or !Rent.valid_attribute?(:startDate, rent.endDate)

		unless rent.valid?
			errors = rent.errors
			return (!errors.get(:airPort_id).present? or !errors.get(:startDate).present? or !errors.get(:endDate).present?)
		end
		true

	end
end
