ActiveAdmin.register Rent do

	index do
		column(:id) { |rent| link_to(rent.id, admin_rent_path(rent)) }
		column(:airPort)
		column("From:", :startDate)
		column("To", :endDate)
		column(:user_id) { |rent| link_to(rent.user.name || [rent.user.first_name, rent.user.last_name].join(' '), admin_user_path(rent.user)) }
		column(:travel_id) { |rent| link_to(rent.try(:travel).car.try { |car| "#{car.brand} #{car.model} #{car.year}" }, admin_travel_path(rent.travel)) }
		column(:amount)
		column(:transaction_id)
		column(:status)
		default_actions
	end


	action_item  :except => :index do
		link_to "Voir sur le site publique", user_rent_url(rent.user, rent), :target => "_blank"
	end

	show do |rent|
		default_main_content
		if !rent.rent_options.blank?
			h3 "Liste des options"
			ul do
				rent.rent_options.each do |option|
					li "#{option.default_label}"
				end
			end
		else
			h3 "Pas d'options"
		end
	end

end
