class SearchController < ApplicationController


  def index
    @rent = Rent.new

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rent }
    end
  end

  def search
    # check valid params
    @travels = []
    if params[:rent]
      @travels = Travel.where('arrival > :end AND departure < :start AND "airPortName" = :airPortName',
                              {:start => params[:rent][:startDate].to_date,
                               :end => params[:rent][:endDate].to_date,
                               :airPortName => params[:rent][:airPortName]})

    end
    @rent = Rent.new(params[:rent])

    respond_to do |format|
      format.html # search.html.erb
      format.json { render json: [@rent, @travels] }
    end
  end


end
