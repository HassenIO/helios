class DashboardsController < ApplicationController

	before_filter :authenticate_user!
	
	def index
		@user = User.find_by_email current_user.email
		@travels = @user.travels
		@next_travel = @travels.order("departure ASC").select{ |t| t.departure > Time.now }.first if !@travels.blank?
		@rents = @user.rents
		@next_rent = @rents.order("startDate ASC").select{ |r| r.startDate > Time.now }.first if !@rents.blank?
	end

end