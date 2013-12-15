class SearchController < ApplicationController

	# before_filter :must_sign_in
	# before_filter :authenticate_user!

	def index
		@rent = Rent.new
		@rent.startDate = Time.now + 1.days
		@rent.endDate = Time.now + 9.days
		# @rent.airPort = AirPort.find(1)

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @rent }
		end
	end

	def search
		@travels = []
		@rent = Rent.new(params[:rent])
		min_waiting = 1
		min_days = 3

		respond_to do |format|
			if !rent_partial_validation(@rent)
				@rent.valid?
				format.html # search.html.erb
				format.json { render json: @rent.errors, status: :unprocessable_entity }
			elsif !min_waiting(min_waiting)
				flash.now[:alert] = "Pour un début de location à moins de #{min_waiting} jours, veuillez contacter notre support <a href=\"#{ENV["WP_ROOT"]}/#contact\" class=\"base\">en cliquant ici</a>.".html_safe
				format.html # search.html.erb
			elsif !min_days(min_days)
				flash.now[:alert] = "Vous devez louer pour au moins #{min_days} jours."
				format.html # search.html.erb
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

	def api_search
		airports = { "CDG" => 1, "ORY" => 2, "BVA" => 3 }
		@nb_days = ((params[:dropoff_date].to_time - params[:pickup_date].to_time)/1.day).ceil
		@travels = Travel.where('arrival > :end AND departure < :start AND "airPort_id" = :airPort_id AND status = 1',
										{:start => params[:pickup_date],
											:end => params[:dropoff_date],
											:airPort_id => airports[params[:airport_id]] })

		respond_to do |format|
			format.xml { render file: "search/api/#{params[:affiliate_id]}", content_type: "application/xml" }
		end
	end



	private

	def rent_partial_validation(rent)
		unless rent.valid?
			errors = rent.errors
			return (!errors.get(:airPort_id).present? or !errors.get(:startDate).present? or !errors.get(:endDate).present?)
		end
		true
	end

	# Get how many days between departure and arrival
	def min_days days 
		start_date = human_to_system_datetime params[:rent][:startDate_date]
		end_date = human_to_system_datetime params[:rent][:endDate_date]

		return ((end_date - start_date)/24/60/60).to_i >= days
	end

	# Get how many days between two dates
	def min_waiting days 
		start_date = Time.now
		end_date = human_to_system_datetime params[:rent][:startDate_date]

		return ((end_date - start_date)/24/60/60).to_i >= days
	end
end
