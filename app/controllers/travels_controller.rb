class TravelsController < ApplicationController

  before_filter :load_user
  # GET /travels
  # GET /travels.json
  def index
    @travels = @user.travels.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @travels }
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
    @travel = @user.travels.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @travel }
    end
  end

  # GET /travels/1/edit
  def edit
    @travel = @user.travels.find(params[:id])
  end

  # POST /travels
  # POST /travels.json
  def create
    @travel = @user.travels.new(params[:travel])

    respond_to do |format|
      if @travel.save
        format.html { redirect_to [@user, @travel], notice: 'Travel was successfully created.' }
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
    @travel = @user.travels.find(params[:id])

    respond_to do |format|
      if @travel.update_attributes(params[:travel])
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
    @travel = @user.travels.find(params[:id])
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


end
