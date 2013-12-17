class AdminPowersController < ApplicationController

	def new_travel_email
		travel = Travel.find_by_id params[:id]
		UserMailer.travel_new(travel).deliver
		render js: "alert(\"Travel mail sent successfully to #{travel.user.name}: #{travel.user.email}\")", status: 200
	end

	def duplicate_travel
		travel = Travel.find_by_id params[:id]

		new_travel = travel.dup
		new_travel.user_id = current_user.id
		new_travel.save

		car = travel.car
		new_car = car.dup
		new_car.travel_id = new_travel.id
		new_car.save

		flash[:notice] = "Travel ##{new_car.id} a été dupliqué avec succés du Travel ##{travel.id} avec “#{current_user.name}” comme propriétaire."
		redirect_to admin_travel_path new_travel
	end

end
