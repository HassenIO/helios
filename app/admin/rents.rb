ActiveAdmin.register Rent do

	index do
		column(:id) { |rent| link_to(rent.id, admin_rent_path(rent)) }
		column(:airPort)
		column("From:", :startDate)
		column("To", :endDate)
		column(:user_id) { |rent| link_to(rent.user.email, admin_user_path(rent.user)) }
		column(:travel_id) { |rent| link_to(rent.try(:travel).car.try { |car| "#{car.brand} #{car.model} #{car.year}" }, admin_travel_path(rent.travel)) }
		column(:car_category) { |rent| rent.try(:travel).try(:car).try(:category).try { |category| "#{category.name} - #{number_to_currency(category.price/100, :precision => 2)}/day" } }
		column(:price) { |rent| rent.try(:payment).try{ |payment| number_to_currency(payment.amount/100, :precision => 2) }}
		column(:status) { |rent| rent.try(:payment).try{ |payment| status_tag(payment.status.to_s) }}
		column(:created_at, :sortable => :created_at)
		default_actions
	end


	action_item  :except => :index do
		link_to "Voir sur le site publique", user_rent_url(rent.user, rent), :target => "blank"
	end


end
