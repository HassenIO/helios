ActiveAdmin.register Rent do

  index do
    column(:id) { |rent| link_to(rent.id, admin_rent_path(rent)) }
    column(:airPort)
    column("From:", :startDate, :sortable => :departure)
    column("To", :endDate)
    column(:user_id) { |rent| link_to(rent.user.email, admin_user_path(rent.user)) }
    column(:travel_id) { |rent| link_to(rent.try(:travel).car.try { |car| "#{car.brand} #{car.model} #{car.year}" }, admin_travel_path(rent.travel)) }
    column(:car_category) { |rent| rent.try(:travel).try(:car).try(:category).try { |category| "#{category.name} - #{category.price}€/day" } }
    column(:price) { |rent| rent.try(:travel).try(:car).try(:category).try { |category| compute_price_for_rent(rent.startDate, rent.endDate, category.price) } }
  end

end
