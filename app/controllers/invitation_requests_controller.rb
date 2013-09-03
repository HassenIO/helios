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
		if ( invitation = InvitationRequest.create params[:invitation_request] )
			# Send an email to the visitor that requested the invitation

			# Send an email to the admin to notice the new invitation request

			# Display the view
			redirect_to invitation_request_path(invitation.id), notice: "Merci #{email} et à bientôt sur TravelerCar."
			return
		else
			redirect_to invitation_request_path(0), alert: "Une erreur interne vient de se produire. Veuillez réessayer dans quelques instants."
			return
		end
	end

	# Show status of an invitation request (only visible after creating an invitation request)
	def show
	end

end
