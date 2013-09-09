class PaymentsController < ApplicationController
	include PricingHelper

	before_filter :authenticate_user!

	load_and_authorize_resource :rent

	load_and_authorize_resource :payment, :through => :rent, :singleton => true


	## GET /payments
	## GET /payments.json
	#def index
	#  @payments = Payment.all
	#
	#  respond_to do |format|
	#    format.html # index.html.erb
	#    format.json { render json: @payments }
	#  end
	#end

	# GET /payments/1
	# GET /payments/1.json
	def show
		@payment = @rent.payment

		@payment.check_payment

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @payment }
		end
	end

	# GET /payments/new
	# GET /payments/new.json
	def new
		if @rent.payment.nil?

			@payment = Payment.new
			@payment.amount = price_for_rent(@rent)

			respond_to do |format|
				format.html # new.html.erb
				format.json { render json: @payment }
			end
		else
			flash[:error] = t("payments.show.payment_existing")
			redirect_to :action => 'show'
		end
	end

	# GET /payments/1/edit
	def edit
		@payment = Payment.find(params[:id])
	end

	# POST /payments
	# POST /payments.json
	def create
		#TODO : compute price in back or verify ?
		if @rent.payment.nil?

			@payment = Payment.new
			@payment.rent = @rent
			@payment.amount = price_for_rent_in_cents(@rent)

			respond_to do |format|
				if @payment.save
					#Fix how to store / config userId Leetchi
					contribution = Leetchi::Contribution.create({"UserID" => ENV["LEETCHI_TARGET_USER_ID"],
																 "WalletID" => 0,
																 "Amount" => @payment.amount,
																 "ClientFeeAmount" => 0,
																 "RegisterMeanOfPayment" => false,
																 "ReturnURL" => user_rent_payment_url(current_user, @rent),
																 "PaymentMethodType" => "cb_visa_mastercard"})


					#save contribution id
					@payment.contribution_id = contribution["ID"]
					@payment.contribution_details = contribution
					@payment.status = :pending
					@payment.save!

					format.html { redirect_to contribution["PaymentURL"] }
					format.json { render json: @payment, status: :created, location: @payment }
				else
					format.html { render action: "new" }
					format.json { render json: @payment.errors, status: :unprocessable_entity }
				end
			end
		else
			flash[:error] = t("payments.show.payment_existing")
			redirect_to :action => 'show'
		end

	end

	# PUT /payments/1
	# PUT /payments/1.json
	def update
		@payment = Payment.find(params[:id])

		respond_to do |format|
			if @payment.update_attributes(params[:payment])
				format.html { redirect_to @payment, notice: 'Payment was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @payment.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /payments/1
	# DELETE /payments/1.json
	def destroy
		@payment = Payment.find(params[:id])
		@payment.destroy

		respond_to do |format|
			format.html { redirect_to payments_url }
			format.json { head :no_content }
		end
	end

end
