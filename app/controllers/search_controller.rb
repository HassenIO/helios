class SearchController < ApplicationController


  def index
    @rent = Rent.new
    @rent.airPort = AirPort.find(1)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rent }
    end
  end

  def search
    # check valid params
    @travels = []
    if params[:rent]
      @travels = Travel.where('arrival > :end AND departure < :start AND "airPort_id" = :airPort_id AND status = 1',
                              {:start => params[:rent][:startDate].to_date,
                               :end => params[:rent][:endDate].to_date,
                               :airPort_id => params[:rent][:airPort_id]})

    end
    @rent = Rent.new(params[:rent])

    respond_to do |format|
      format.html # search.html.erb
      format.json { render json: [@rent, @travels] }
    end
  end


end
