class NavigationsController < ApplicationController

	def index
		respond_to do |format|
			unless current_user.nil?
				format.js
			else
				format.js { render :nothing => true, :status => 200, :content_type => "text/javascript" }
			end
		end
	end

end
