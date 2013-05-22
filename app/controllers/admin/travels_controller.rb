class Admin::TravelsController < Admin::BaseController


  #before_filter :load_user, :only => [:index, :show]
  #check if admin only

  # GET /travels
  # GET /travels.json
  def index
    @travelsPending = Travel.find_all_by_status(Travel::STATUS[:pending])
    @travelsActive = Travel.find_all_by_status(Travel::STATUS[:active])
    @travelsRent = Travel.find_all_by_status(Travel::STATUS[:rent])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @travelsPending }
    end
  end

  # GET /travels/1
  # GET /travels/1.json
  def show

    @travel = Travel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @travel }
    end
  end

  # GET /travels/new
  # GET /travels/new.json
  def new

    @travel= Travel.new


    @travel.car ||= Car.new
    @travel.airPort ||= AirPort.find(1)
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @travel }
    end
  end

  # GET /travels/1/edit
  def edit
    @travel = Travel.find(params[:id])
    @travel.car.category ||= Category.new

  end

  # POST /travels
  # POST /travels.json
  def create
    @travel = Travel.new(params[:travel])

    respond_to do |format|
      if @travel.save
        format.html { redirect_to admin_travel_path(@travel), notice: 'Travel was successfully created.' }
        format.json { render json: @travel, status: :created, location: @travel }
      else
        flash[:error] = 'Travel is not valid, please fix it'
        format.html { render action: "new" }
        format.json { render json: @travel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /travels/1
  # PUT /travels/1.json
  def update
    @travel = Travel.find(params[:id])

    #TODO : invalid status:active or rent if no category

    respond_to do |format|
      @travel.attributes = params[:travel]
      if @travel.save(:validate => false)
        format.html { redirect_to admin_travel_path(@travel), notice: 'Travel was successfully updated.' }
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
    @travel = Travel.find(params[:id])
    @travel.destroy

    respond_to do |format|
      format.html { redirect_to admin_travels_path }
      format.json { head :no_content }
    end
  end


end
