class AnonymousTravelsController < ApplicationController

  before_filter :authenticate_user!, :only => [:checkout]

  # GET /travels/new
  # GET /travels/new.json
  def new
    @travel = Travel.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @travel }
    end
  end

  # GET /travels/1/edit
  #def edit
  #  @travel = @user.travels.find(params[:id])
  #end

  # POST /travels
  # POST /travels.json
  def create
    @travel = Travel.new(params[:travel])
    session[:travel] = @travel
    #ok go to login page
    #session["totos_return_to"] = user_travel_url(current_user)
    redirect_to :action => 'checkout'

    #how to deal after login with session[:travel]

  end


  def checkout

    @user = current_user
    @travel = session[:travel]

    #puts current_user.inspect
    #puts session[:travel].inspect

    current_user.travels << @travel

    if @travel.save
       redirect_to user_travel_url(@user, @travel), notice: 'Travel was successfully created.'
    else
       render controller: "travels", action: "new"
    end

  end


end
