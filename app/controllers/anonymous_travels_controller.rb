class AnonymousTravelsController < ApplicationController


  def index
    @travel = Travel.new

    respond_to do |format|
      format.html # index.html.erb
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
