class RentsController < ApplicationController
	include PricingHelper

	before_filter :authenticate_user!, except: :new
	load_and_authorize_resource :user, :except => :new
	load_and_authorize_resource :through => :user, :except => :new

	COMMON_DRIVER_USER_FIELDS = ["first_name", "last_name", "address", "city", "country", "zip_code", "license", "license_year", "birth_date"]

	# GET /rents
	# GET /rents.json
	def index
		@rents = Rent.where user_id: current_user, status: :paid
		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @rents }
		end
	end


	# GET /rents/1
	# GET /rents/1.json
	def show
		
		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @rent }
		end
	end

	def new
		if user_signed_in?
			@user = current_user

			if params[:rent]
				@rent = Rent.new(params[:rent])

				@rent.travel = Travel.find(params[:rent][:travel_id])

				#Fill driver info with user ones
				@rent.driver = Driver.new(@user.attributes.select{ |key, _| COMMON_DRIVER_USER_FIELDS.include?(key) })

				@options = RentOptions.all
				@rentPrice = number_of_days(@rent) * @rent.travel.car.category.price_in_euros * reduc(@rent, @rent.travel.car.category)
				@rentPrice = @rentPrice.to_i if @rentPrice == @rentPrice.to_i

				respond_to do |format|
					format.html # register.html.erb
					format.json { render json: @rent }
				end
			else
				redirect_to '/search'
			end
		else
			session[:redirect_rent] = request.original_url
			redirect_to new_user_session_path, notice: "Veuillez vous connecter (ou vous inscrire) pour poursuivre."
		end
	end

	# GET /rents/1/edit
	def edit

	end

	# POST /rents
	# POST /rents.json
	def create

		@rent = Rent.new(params[:rent])

		price = price_for_rent(@rent, price: @rent.travel.car.category.price * reduc(@rent, @rent.travel.car.category))
		params[:options].each { |option| price += option[1].to_f } if !params[:options].blank?

		@rent.user = current_user
		@rent.amount = price
		@rent.status = :unpaid

		@options = RentOptions.all
		@rentPrice = number_of_days(@rent) * @rent.travel.car.category.price_in_euros * reduc(@rent, @rent.travel.car.category)
		@rentPrice = @rentPrice.to_i if @rentPrice == @rentPrice.to_i


		respond_to do |format|
			if @rent.save
				format.html { redirect_to @rent.paypal_url( user_rents_url(current_user), payment_notification_url(@rent) ) }
			else
				format.html { render action: "new" }
				format.json { render json: @rent.errors, status: :unprocessable_entity }
			end
		end
	end

	# PUT /rents/1
	# PUT /rents/1.json
	def update

		respond_to do |format|
			if @rent.update_attributes(params[:rent])
				AdminMailer.rent_notification(@rent).deliver
				format.html { redirect_to new_user_rent_payment_url(@user, @rent) }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @rent.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /rents/1
	# DELETE /rents/1.json
	def destroy
		@travel = @rent.travel
		@travel.status = :active
		@travel.save(:validate => false)

		@rent.destroy

		respond_to do |format|
			format.html { redirect_to user_rents_url(@user) }
			format.json { head :no_content }
		end
	end

	def cgv
	end

	def payment
	end

end
