class TravelsController < ApplicationController

	load_and_authorize_resource

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
			@travel.departure = 7.days.from_now
			@travel.arrival = 17.days.from_now
		end

		@travel.car ||= Car.new
		
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
				AdminMailer.travel_new(@travel).deliver
				UserMailer.travel_new(@travel).deliver
				format.html { redirect_to [@user, @travel], notice: t("flash.travels.create.success") }
				format.json { render json: @travel, status: :created, location: @travel }
			else
				flash.now[:alert] = t("flash.travels.create.alert")
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
				AdminMailer.travel_update(@travel).deliver
				format.html { redirect_to [@user, @travel], notice: t("flash.travels.update.success") }
				format.json { head :no_content }
			else
				flash.now[:alert] = t("flash.travels.update.alert")
				format.html { render action: "edit" }
				format.json { render json: @travel.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /travels/1
	# DELETE /travels/1.json
	def destroy
		@travel.status = :canceled_by_user
		if @travel.save
			flash[:notice] = t("flash.travels.delete.success")
		else
			flash[:alert] = t("flash.travels.delete.failure")
		end

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
