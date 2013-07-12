class TravelsController < ApplicationController

  load_and_authorize_resource

  before_filter :load_user, :only => [:index, :show]

  before_filter :load_current_user, :except => [:index, :show]

  before_filter :authenticate_user!, :except => :show

  # GET /travels
  # GET /travels.json
  def index

    @travels = @user.travels.all.sort_by!{ |t| t.departure}

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
      @travel.arrival = Time.now + 6.days
      @travel.departure = Time.now + 1.days
    end

    @travel.car ||= Car.new
    @travel.airPort ||= AirPort.find(1)
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
    @travel = @user.travels.new(params[:travel])
    @travel.status = :pending

    respond_to do |format|
      if @travel.save
        format.html { redirect_to cgv_user_travel_url(@user, @travel), notice: 'Travel was successfully created.' }
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
        AdminMailer.travel_notification(@travel).deliver
        format.html { redirect_to [@user, @travel], notice: 'Travel was successfully updated.' }
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


  def cgv

  end

  private

  def load_user
    @user = User.find(params[:user_id])
  end

  def load_current_user
    @user = current_user
  end


end
