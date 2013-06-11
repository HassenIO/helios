ActiveAdmin.register Travel do


  scope :all, :default => true
  scope :active do |travels|
    travels.where(:status => Travel::STATUS[:active])
  end
  scope :pending do |travels|
    travels.where(:status => Travel::STATUS[:pending])
  end
  scope :rent do |travels|
    travels.where(:status => Travel::STATUS[:rent])
  end


  index do
    column(:id) { |travel| link_to(travel.id, admin_travel_path(travel)) }
    column(:airPort)
    column(:departure_date, :sortable => :departure)
    column(:departure_time, :sortable => :departure)
    column(:arrival_date, :sortable => :arrival)
    column(:arrival_time, :sortable => :arrival)
    column(:status) { |travel| status_tag(travel.status.to_s) }
    column(:car_id) { |travel| travel.car.try { |car| "#{car.brand} #{car.model} #{car.year}" } }
    column(:car_category) { |travel| travel.try(:car).try(:category).try { |category| "#{category.name} - #{category.price}euros /day" } }
    column(:created_at, :sortable => :created_at)
  end


  form do |f|

    f.inputs :arrival, :departure, :airPort, :has_accepted_cgv, :user


    #f.inputs :status,  :as => :select,      :collection =>
    f.inputs do
      f.input :status, :as => :select, :collection => Travel::STATUS.keys
    end


    f.inputs "Car", for: [:car, f.object.car || Car.new] do |car_f|
      car_f.inputs :brand, :model, :fuel, :nbSeats, :km, :year, :license, :desc, :hasChildSeat, :hasGps,
                   :hasCarRadio, :isSmoker, :acceptedPets, :hasAirConditioning,
                   :filepicker1_url, :filepicker2_url, :filepicker3_url, :category
    end

    f.buttons
  end


  controller do

    def update
      @travel = Travel.find(params[:id])

      #TODO : invalid status:active or rent if no category


      @travel.attributes = params[:travel]
      if @travel.save(:validate => false)
        redirect_to :action => :show, :notice => "Travel was successfully updated."
      else
        render action: "edit"
      end
    end
  end


end

