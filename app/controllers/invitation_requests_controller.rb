class InvitationRequestsController < ApplicationController

	# Display the invitation request form (email)
	def index
		# Display the form to request an invitation
	end

	# Create a new invitation request
	def create
		email = params[:invitation_request][:email]

		# Check if the email is for an active user
		if User.find_by_email email
			redirect_to invitation_request_path(0), alert: "Vous êtes déjà membre de TravelerCar."
			return
		end

		# Check if the email is already in the invitation request list
		if InvitationRequest.find_by_email email
			redirect_to invitation_request_path(0), alert: "Patience #{email} ! Vous avez déjà demandé une invitation à rejoindre TravelerCar."
			return
		end

		# Add the current email to the invitation request list
		invitation = InvitationRequest.create params[:invitation_request]
		if invitation && !invitation.id.nil?
			# Send an email to the visitor that requested the invitation
			InvitationRequestMailer.new_request( email ).deliver

			# Display the view
			redirect_to "#{ENV['WP_ROOT']}/invitation-request-confirmation"
			return
		else
			redirect_to invitation_requests_path, alert: "L'adresse email ne doit pas être vide."
		end
	end

	# Show status of an invitation request (only visible after creating an invitation request)
	def show
	end

end
