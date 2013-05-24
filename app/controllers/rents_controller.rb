class RentsController < ApplicationController

  load_and_authorize_resource

  before_filter :load_current_user
  before_filter :authenticate_user!

  # GET /rents
  # GET /rents.json
  def index
    @rents = @user.rents.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rents }
    end
  end


  # GET /rents/1
  # GET /rents/1.json
  def show
    #@rent = Rent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @rent }
    end
  end

  def new
    if params[:rent]
      @rent = Rent.new(params[:rent])

      @rent.travel = Travel.find(params[:rent][:travel_id])
      @rent.driver = Driver.new

      respond_to do |format|
        format.html # register.html.erb
        format.json { render json: @rent }
      end
    else
      redirect_to '/search'
    end
  end

  # GET /rents/1/edit
  def edit
    #@rent = Rent.find(params[:id])
  end

  # POST /rents
  # POST /rents.json
  def create

    @rent = Rent.new(params[:rent])

    @rent.user = current_user

    respond_to do |format|
      if @rent.save
        format.html { redirect_to cgv_user_rent_path(@user, @rent), notice: 'Rent was successfully created.' }
        format.json { render json: @rent, status: :created, location: @rent }
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
        format.html { redirect_to [@user, @rent], notice: 'Rent was successfully updated.' }
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
    @rent.travel.status = :active
    @rent.destroy


    respond_to do |format|
      format.html { redirect_to user_rents_url(@user) }
      format.json { head :no_content }
    end
  end

  def cgv

  end

  def load_current_user
    @user = current_user
  end
end
