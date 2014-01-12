class ApiMgt < ActiveRecord::Base
  attr_accessible :affiliate_id, :airport_id, :click, :driver_age, :dropoff_date, :dropoff_time, :max_price, :min_price, :nb_clicks, :nb_days, :nb_travels, :pickup_date, :pickup_time, :response, :token, :travels
end
