class InvitationRequestMailer < ActionMailer::Base

	def new_request email
		@email = email
		mail(	to: @email,
				from: ENV['MAILER_SUPPORT'],
				subject: "TravelerCar : Votre demande d'invitation",
				template_path: 'invitation_request_mailer',
        		template_name: 'new_request'
        	)
	end
	
end
