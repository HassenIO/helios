class CarsController < ApplicationController

  before_filter :load_user

  # GET /cars
  # GET /cars.json
  def index
    @cars = @user.cars.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cars }
    end
  end

  # GET /cars/1
  # GET /cars/1.json
  def show
    @car = @user.cars.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @car }
    end
  end

  # GET /cars/new
  # GET /cars/new.json
  def new
    @car = @user.cars.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @car }
    end
  end

  # GET /cars/1/edit
  def edit
    @car = @user.cars.find(params[:id])
  end

  # POST /cars
  # POST /cars.json
  def create
    @car = @user.cars.new(params[:car])

    respond_to do |format|
      if @car.save
        format.html { redirect_to [@user,@car], notice: 'Car was successfully created.' }
        format.json { render json: @car, status: :created, location: @car }
      else
        format.html { render action: "new" }
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /cars/1
  # PUT /cars/1.json
  def update
    @car = Car.find(params[:id])

    respond_to do |format|
      if @car.update_attributes(params[:car])
        format.html { redirect_to [@user,@car], notice: 'Car was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cars/1
  # DELETE /cars/1.json
  def destroy
    @car = @user.cars.find(params[:id])
    @car.destroy

    respond_to do |format|
      format.html { redirect_to user_cars_url(@user) }
      format.json { head :no_content }
    end
  end


  def load_user
    @user = User.find(params[:user_id])
  end
end
