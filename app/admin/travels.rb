ActiveAdmin.register Travel do

    # config.clear_sidebar_sections!

    action_item except: :index do
        link_to "Voir sur le site publique", user_travel_url( travel.user, travel ), target: "_blank"
    end


    scope :all, default: true
    scope :pending do |travels|
        travels.where(status: Travel::STATUS[:pending])
    end
    scope :active do |travels|
        travels.where(status: Travel::STATUS[:active])
    end
    scope :rent do |travels|
        travels.where(status: Travel::STATUS[:rent])
    end
    scope :canceled do |travels|
        travels.where(status: Travel::STATUS[:canceled])
    end
    scope :terminated do |travels|
        travels.where(status: Travel::STATUS[:terminated])
    end


    index do
        column(:id, sortable: :id) { |travel| link_to(travel.id, admin_travel_path(travel)) }
        column(:user)
        column(:city) { |travel| travel.user.city }
        column(:phone) { |travel| travel.user.license }
        column(:email) { |travel| link_to(travel.user.email, "mailto:#{travel.user.email}?body=Bonjour #{travel.user.name},%0A%0A%0A") }
        column(:car_id) { |travel| travel.car.try { |car| link_to( "#{car.brand} - #{car.model} (#{car.year})", user_travel_url(travel.user, travel), target: "about" ) } }
        column(:airPort)
        column(:rdv, sortable: :rdv)
        column(:departure, sortable: :departure)
        column(:arrival, sortable: :arrival)
        column("nb") { |travel| (travel.count_person.nil?) ? "-" : travel.count_person }
        column(:ph) { |travel| (travel.has_image?) ? status_tag("OK", :on, class: "bullet") : status_tag("NO", :canceled, class: "bullet") }
        column(:pr) { |travel| (travel.user.has_complete_profile?) ? status_tag("OK", :on, class: "bullet") : status_tag("NO", :canceled, class: "bullet") }
        column(:status) { |travel| status_tag(travel.status.to_s) }
        column(:car_category) { |travel| travel.try(:car).try(:category).try { |category| "#{category.name} (#{category.price/100}€/day)" } }
    end

    show do
        panel "Travel details" do
            attributes_table_for travel do
                row(:id) { link_to "#{travel.id} (click to view)", user_travel_path(I18n.locale, travel.user, travel), target: "_blank" }
                row(:airport) { link_to travel.airPort.name, admin_air_port_path(travel.airPort) }
                row(:departure) { travel.departure }
                row("Departure flight num.") do
                    if travel.flight_n_departure.blank?
                        strong "No flight number provided"
                    else
                        travel.flight_n_departure
                    end
                end
                row(:rdv) do
                    h = ((travel.departure - travel.rdv).to_i)/3600
                    "#{l travel.rdv, format: :long} (#{h} hours before departure)"
                end
                row(:return) { travel.arrival }
                row("Return flight num.") do
                    if travel.flight_n_arrival.blank?
                        strong "No flight number provided"
                    else
                        travel.flight_n_arrival
                    end
                end
                row(:user) { link_to travel.user.name, admin_user_path(travel.user) }
                row("Did we contact the client?") { travel.contacted }
                row("How many people?") { travel.count_person }
                row("Do we have regulatory document?") { travel.reg_document }
                row(:car) { "#{travel.car.brand} #{travel.car.model} (#{travel.car.year})" }
                row(:commercial_text) { travel.commercial_text }
                row(:status) { travel.status }
            end
        end
        active_admin_comments
    end

    sidebar "Admin Super Powers", only: :show do
        ul do
            li link_to "Email to #{travel.user.name}", "mailto:#{travel.user.email}?body=Bonjour #{travel.user.name},%0A%0A%0A"
            li link_to "Send \"New Travel\" email", admin_powers_new_travel_email_path(travel), remote: true
        end
    end




    form do |f|

        f.inputs do
            f.input :airPort
            f.input :departure
            f.input :flight_n_departure, label: "Num. de vol Allée"
            f.input :arrival
            f.input :flight_n_arrival, label: "Num. de vol Retour"
        end

        f.inputs do
            f.input :user, label: "Nom de l'utilisateur"
            f.input :count_person, label: "Nombre de personnes attendues", as: :select, collection: (1..9)
            f.input :contacted, as: :select, collection: ["YES", "NO"], label: "A-t-on prit contact avec le client ?"
            f.input :rdv, label: "Date/Heure de RDV"
        end

        f.inputs do
            f.input :reg_document, label: "URL carte grise"
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

        f.inputs do
            f.input :status, :as => :select, :collection => Travel::STATUS.keys
        end

        f.buttons
        end


        controller do

            def update
                @travel = Travel.find params[:id]

                @travel.attributes = params[:travel]
                if @travel.status == :active && @travel.car.category.nil?
                    render action: "edit", :notice => "If 'active' you should select a category"
                elsif @travel.save(:validate => false)
                    redirect_to :action => :show, :notice => "Travel was successfully updated."
                else
                    render action: "edit"
                end

            end
        end


    end

