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
		default_actions
	end

	action_item :except => :index do
		link_to "Voir sur le site publique", user_travel_url(travel.user, travel), :target => "blank"
	end


	form do |f|

		f.inputs :departure, :arrival, :airPort, :has_accepted_cgv, :user


		f.inputs do
			f.input :status, :as => :select, :collection => Travel::STATUS.keys
		end


		f.inputs "Car", for: [:car, f.object.car || Car.new] do |car_f|

			car_f.inputs do
				car_f.input :brand
				car_f.input :model
				car_f.input :year
				car_f.input :license

				car_f.input :transmission, :as => :select, :collection => [:automatic, :manual]
				car_f.input :fuel, :as => :select, :collection => [:essence, :diesel]
				car_f.input :km, :as => :select, :collection => [['0-50000 km', 0], ['50000-100000 km', 50000], ['100000-150000 km', 100000], ['150000 km et plus', 150000]]
				car_f.input :nbSeats, :as => :select, :collection => 2..9

				car_f.input :desc
				car_f.input :hasChildSeat
				car_f.input :hasGps
				car_f.input :hasCarRadio
				car_f.input :isSmoker
				car_f.input :acceptedPets
				car_f.input :hasAirConditioning
				car_f.input :filepicker1_url
				car_f.input :filepicker2_url
				car_f.input :filepicker3_url
				car_f.input :category
			end

		end

		f.inputs do
			f.input :commercial_text, :as => :ckeditor
		end

		f.buttons
	end


	controller do

		def update
			@travel = Travel.find(params[:id])

			@travel.attributes = params[:travel]
			if @travel.status == :active && @travel.car.category.nil?
				#TODO : invalid status:active or rent if no category
				render action: "edit", :notice => "If 'active' you should select a category"
			elsif @travel.save(:validate => false)
				redirect_to :action => :show, :notice => "Travel was successfully updated."
			else
				render action: "edit"
			end

		end
	end


end

