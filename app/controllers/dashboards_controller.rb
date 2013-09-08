class DashboardsController < ApplicationController

	before_filter :authenticate_user!
	
	def index
		@user = User.find_by_email current_user.email
	end

end
