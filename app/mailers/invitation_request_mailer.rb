class InvitationRequestMailer < ActionMailer::Base

	default from: ENV['MAILER_FROM']

	def new_request email
		@email = email
		mail( to: @email,
				subject: "TravelerCar : Votre demande d'invitation",
				template_path: 'invitation_request_mailer',
        		template_name: 'new_request'
        	)
	end
	
end
