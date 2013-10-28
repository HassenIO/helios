class AdminPowersController < ApplicationController

    def new_travel_email
        travel = Travel.find_by_id params[:id]
        UserMailer.travel_new(travel).deliver
        render js: "alert(\"Travel mail sent successfully to #{travel.user.name}: #{travel.user.email}\")", status: 200
    end

end
