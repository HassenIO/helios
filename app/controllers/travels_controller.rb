class TravelsController < ApplicationController

	load_and_authorize_resource

	before_filter :must_sign_in
	before_filter :authenticate_user!, :except => :show
	before_filter :load_user, :only => [:index, :show]
	before_filter :load_current_user, :except => [:index, :show]

	# GET /travels
	# GET /travels.json
	def index

		@travels = @user.travels.all.sort_by!{ |t| t.departure }

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @travels }
		end
	end

	# GET /travels/1
	# GET /travels/1.json
	def show

		if params[:rent]
			@rent = Rent.new(params[:rent])
			@rent.set_datetimes
		end

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @travel }
		end
	end

	# GET /travels/new
	# GET /travels/new.json
	def new
		if session[:travel]
			@travel = Travel.new(session[:travel])
			session.delete(:travel)
		else
			@travel= @user.travels.new
			@travel.departure = "01/11/2013 09:00"
			@travel.arrival = "10/11/2013 18:00"
			# @travel.departure = Time.now + 1.days
			# @travel.arrival = Time.now + 10.days
		end

		@travel.car ||= Car.new
		# @travel.airPort ||= AirPort.find(1) # WHY THIS ???
		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @travel }
		end
	end

	# GET /travels/1/edit
	def edit
	end

	# POST /travels
	# POST /travels.json
	def create
		# Change departure/arrival datetime format.
		travel = params[:travel]
		travel[:departure] = human_to_system_datetime(travel[:departure])
		travel[:arrival] = human_to_system_datetime(travel[:arrival])

		@travel = @user.travels.new(travel)
		@travel.status = :pending

		respond_to do |format|
			if @travel.save
				AdminMailer.travel_notification(@travel).deliver
				format.html { redirect_to [@user, @travel], notice: "Votre demande a bien été prise en compte." }
				format.json { render json: @travel, status: :created, location: @travel }
			else
				format.html { render action: "new" }
				format.json { render json: @travel.errors, status: :unprocessable_entity }
			end
		end
	end

	# PUT /travels/1
	# PUT /travels/1.json
	def update

		respond_to do |format|
			if @travel.update_attributes(params[:travel])
				format.html { redirect_to [@user, @travel], notice: 'Votre demande a bien été mise à jour.' }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @travel.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /travels/1
	# DELETE /travels/1.json
	def destroy
		@travel.destroy

		respond_to do |format|
			format.html { redirect_to user_travels_url(@user) }
			format.json { head :no_content }
		end
	end




	private


	def load_user
		@user = User.find(params[:user_id])
	end

	def load_current_user
		@user = current_user
	end


end
