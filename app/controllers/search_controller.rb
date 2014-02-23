class SearchController < ApplicationController

	def index
		@rent = Rent.new
		@rent.startDate = Time.now + 2.days
		@rent.endDate = Time.now + 9.days
		# @rent.airPort = AirPort.find(1)

		respond_to do |format|
			format.html
			format.json { render json: @rent }
		end
	end

	def search
		@travels = []
		@rent = Rent.new(params[:rent])
		min_waiting = 1
		min_days = 1

		respond_to do |format|
			if !rent_partial_validation(@rent)
				@rent.valid?
				format.html
				format.json { render json: @rent.errors, status: :unprocessable_entity }
			elsif !min_waiting(min_waiting)
				flash.now[:alert] = "Pour un début de location à moins de #{min_waiting} jours, veuillez contacter notre support <a href=\"#{ENV["WP_ROOT"]}/#contact\" class=\"base\">en cliquant ici</a>.".html_safe
				format.html
			elsif !min_days(min_days)
				flash.now[:alert] = "Vous devez louer pour au moins #{min_days} jours."
				format.html
			else
				@travels = Travel.where('arrival > :end AND departure < :start AND "airPort_id" = :airPort_id AND status = 1',
										{:start => @rent.startDate,
											:end => @rent.endDate,
											:airPort_id => @rent.airPort_id}).sort_by { |travel| travel.car.category.price }

				format.html
				format.json { render json: [@rent, @travels] }
			end
		end
	end

	def api_search
		airports = { "CDG" => 1, "ORY" => 2, "BVA" => 3 }

		@nb_days = ((params[:dropoff_date].to_time - params[:pickup_date].to_time)/1.day).ceil

		@travels = Travel.where('arrival > :end AND departure < :start AND "airPort_id" = :airPort_id AND status = 1',
										{:start => "#{params[:pickup_date]} #{params[:pickup_time]}",
											:end => "#{params[:dropoff_date]} #{params[:dropoff_time]}",
											:airPort_id => airports[params[:airport_id]] }).sort_by { |travel| travel.car.category.price }

		@api = ApiMgt.new
		@api.affiliate_id = params[:affiliate_id]
		@api.airport_id = airports[params[:airport_id]]
		@api.click = false
		@api.driver_age = params[:driver_age]
		@api.dropoff_date = params[:dropoff_date]
		@api.dropoff_time = params[:dropoff_time]
		@api.max_price = @travels.last.car.category.price * @nb_days
		@api.min_price = @travels.first.car.category.price * @nb_days
		@api.nb_clicks = 0
		@api.nb_days = @nb_days
		@api.nb_travels = @travels.count
		@api.pickup_date = params[:pickup_date]
		@api.pickup_time = params[:pickup_time]
		@api.response = @travels
		@api.token = Digest::SHA1.hexdigest("aB #{params[:affiliate_id]} % #{Time.now} (#{rand(0..999)}) yZ")
		@api.travels = ""

		@api.save

		@rent = Rent.new
		@rent.startDate = Time.strptime( "#{params[:pickup_date]} #{params[:pickup_time]}", "%Y-%m-%d %H:%M" )
		@rent.endDate = Time.strptime( "#{params[:dropoff_date]} #{params[:dropoff_time]}", "%Y-%m-%d %H:%M" )
		
		respond_to do |format|
			format.xml { render file: "search/api/#{params[:affiliate_id]}", content_type: "application/xml" }
		end
	end

	def api_redirect
		travel = Travel.find params[:travel]

		api = ApiMgt.find_by_token params[:token]
		api.click = true
		api.increment :nb_clicks
		api.travels = "#{api.travels}#{travel.id},"
		api.save

		redirect_to user_travel_url(travel.user, travel)
	end



	private

	def rent_partial_validation(rent)
		unless rent.valid?
			errors = rent.errors
			return (!errors.get(:airPort_id).present? or !errors.get(:startDate).present? or !errors.get(:endDate).present?)
		end
		true
	end

	def min_days days 
		start_date = human_to_system_datetime params[:rent][:startDate_date]
		end_date = human_to_system_datetime params[:rent][:endDate_date]

		return ((end_date - start_date)/24/60/60).to_i >= days
	end

	def min_waiting days 
		start_date = Time.now
		end_date = human_to_system_datetime params[:rent][:startDate_date]

		return ((end_date - start_date)/24/60/60).to_i >= days
	end
end
