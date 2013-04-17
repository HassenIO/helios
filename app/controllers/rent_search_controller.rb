class RentSearchController < ApplicationController

  def index
    @travel = Travel.new()
  end

  def search

    # check valid params
    @travels = Travel.where('arrival > :arrival AND departure < :departure AND "airPortName" = :airPortName',
                            {:arrival => params[:travel][:arrival].to_date,
                             :departure => params[:travel][:departure].to_date,
                             :airPortName => params[:travel][:airPortName]})
    @travel = Travel.new(params[:travel])
  end

end
