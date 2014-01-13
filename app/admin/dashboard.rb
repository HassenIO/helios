ActiveAdmin.register_page "Dashboard" do

	menu :priority => 1, :label => proc { I18n.t("active_admin.dashboard") }

	content :title => proc { I18n.t("active_admin.dashboard") } do


		# Here is an example of a simple dashboard with columns and panels.
		#
		columns do
			column do
				panel "Pending Parking" do
					table_for Travel.find_all_by_status(Travel::STATUS[:pending], :order => 'created_at asc').each do |travel|
						column(:id) {|travel| link_to(travel.id, admin_travel_path(travel)) }
						column(:airPort)
						column(:departure_date)
						column(:departure_time)
						column(:arrival_date)
						column(:arrival_time)
						column(:status) {|travel| status_tag(travel.status.to_s) }
						column(:created_at, :sortable => :created_at)
					end
				end

				panel "Active Parking" do
					table_for Travel.find_all_by_status(Travel::STATUS[:active], :order => 'created_at asc').each do |travel|
						column(:id) {|travel| link_to(travel.id, admin_travel_path(travel)) }
						column(:airPort)
						column(:departure_date)
						column(:departure_time)
						column(:arrival_date)
						column(:arrival_time)
						column(:status) {|travel| status_tag(travel.status.to_s) }
						column(:created_at, :sortable => :created_at)
					end
				end

				panel "Rent Parking" do
					table_for Travel.find_all_by_status(Travel::STATUS[:rent], :order => 'created_at asc').each do |travel|
						column(:id) {|travel| link_to(travel.id, admin_travel_path(travel)) }
						column(:airPort)
						column(:departure_date)
						column(:departure_time)
						column(:arrival_date)
						column(:arrival_time)
						column(:status) {|travel| status_tag(travel.status.to_s) }
						column(:created_at, :sortable => :created_at)
					end
				end
			end

			column do
				panel "Next departures" do
					table_for Travel.where("rdv > '#{Time.now}' AND rdv <= '#{Time.now + 7.days}' AND status = 1").each do |travel|
						column(:id) { |travel| link_to("Travel ##{travel.id}", admin_travel_path(travel.id)) }
						column(:airport) { |travel| travel.airPort.name }
						column(:user) { |travel| link_to travel.user.name, admin_user_path(travel.user) }
						column("Date/Time") { |travel| status_tag travel.rdv.strftime("%a %d %b - %H:%M"), ((travel.rdv > Time.now + 2.days)? :active : :canceled) }
					end
				end
				panel "Next returns" do
					table_for Travel.where("arrival > '#{Time.now}' AND arrival <= '#{Time.now + 7.days}' AND status = 1").each do |travel|
						column(:id) { |travel| link_to("Travel ##{travel.id}", admin_travel_path(travel.id)) }
						column(:airport) { |travel| travel.airPort.name }
						column(:user) { |travel| link_to travel.user.name, admin_user_path(travel.user) }
						column("Date/Time") { |travel| status_tag travel.arrival.strftime("%a %d %b - %H:%M"), ((travel.arrival > Time.now + 2.days)? :active : :canceled) }
					end
				end
				panel "Last users" do
					table_for User.order('id desc').limit(10).each do |user|
						column(:email)    {|user| link_to(user.email, admin_user_path(user)) }
						column(:first_name)
						column(:last_name)
						column(:created_at, :sortable => :created_at)
					end
				end
				
			end

		end # content
	end


end
