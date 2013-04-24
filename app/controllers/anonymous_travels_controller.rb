class AnonymousTravelsController < ApplicationController

  # GET /travels/new
  # GET /travels/new.json
  def new
    @travel = Travel.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @travel }
    end
  end

  # POST /travels
  # POST /travels.json
  def create

    #@travel = Travel.new(params[:travel])
    session[:travel] = params[:travel]

    redirect_to new_travel_path
  end

end
