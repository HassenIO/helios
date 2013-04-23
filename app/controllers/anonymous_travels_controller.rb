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
    print("create")
    @travel = Travel.new(params[:travel])
    session[:travel] = @travel

    print("------------------- travel is in session create ---------------- ")

    redirect_to new_user_travel_path(current_user)
  end

end
