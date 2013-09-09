ActiveAdmin.register Invitation do

	scope "Invitations encore actives (statut = ON)", :active_invitation

	index do
		column "Code d'invitation", :code
		column "Qui en bénéficie ?", :desc
		column "Statut", :status do |invitation|
			status_tag(invitation.status.downcase)
		end
		column "Combien en ont bénéficié ?", :count
		default_actions
	end

	form do |f|
		f.inputs do
			f.input :code, label: "Code d'invitation"
			f.input :desc, label: "Bienvenue QUI ?"
			f.input :status, label: "Statut du code d'invitation", as: :select, collection: ['ON', 'OFF']
		end
		f.actions
	end
  
end
