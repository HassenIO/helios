class PaymentsController < ApplicationController

  before_filter :load_rent

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
    @payment = Payment.new

    nbDays = (@rent.endDate-@rent.startDate)/1.day.ceil

    @payment.amount = @rent.travel.car.category.price*100*nbDays

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @payment }
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
    @payment = Payment.new(params[:payment])
    @payment.rent = @rent

    respond_to do |format|
      if @payment.save
        #Fix how to store / config userId Leetchi
        #Fix url return
        contribution = Leetchi::Contribution.create({"UserID" => 334140,
                                                     "WalletID" => 0,
                                                     "Amount" => @payment.amount,
                                                     "ClientFeeAmount" => 0,
                                                     "RegisterMeanOfPayment" => false,
                                                     "ReturnURL" => user_rent_payment_url(current_user, @rent),
                                                     "PaymentMethodType" => "cb_visa_mastercard"})

        print contribution

        #save contribution id
        @payment.contribution_id = contribution["ID"]
        @payment.contribution_details = contribution
        @payment.status = :pending
        @payment.save!

        format.html { redirect_to contribution["PaymentURL"] }
        #format.json { render json: @booking, status: :created, location: @booking }
      else
        format.html { render action: "new" }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
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

  def load_rent
    @rent = Rent.find(params[:rent_id])
  end
end
