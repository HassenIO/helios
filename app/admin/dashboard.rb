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
			end

			column do
				panel "Next departures" do
					table_for Travel.where("rdv > '#{Time.now}' AND rdv <= '#{Time.now + 7.days}' AND status = 1").order('rdv desc').each do |travel|
						column(:id) { |travel| link_to("Travel ##{travel.id}", admin_travel_path(travel.id)) }
						column(:airport) { |travel| travel.airPort.name }
						column(:user) { |travel| link_to travel.user.name, admin_user_path(travel.user) }
						column("Date/Time") { |travel| status_tag travel.rdv.strftime("%a %d %b - %H:%M"), ((travel.rdv > Time.now + 2.days)? :active : :canceled) }
					end
				end
				panel "Next returns" do
					table_for Travel.where("arrival > '#{Time.now}' AND arrival <= '#{Time.now + 7.days}' AND status = 1").order('arrival desc').each do |travel|
						column(:id) { |travel| link_to("Travel ##{travel.id}", admin_travel_path(travel.id)) }
						column(:airport) { |travel| travel.airPort.name }
						column(:user) { |travel| link_to travel.user.name, admin_user_path(travel.user) }
						column("Date/Time") { |travel| status_tag travel.arrival.strftime("%a %d %b - %H:%M"), ((travel.arrival > Time.now + 2.days)? :active : :canceled) }
					end
				end
			end

		end # content
	end


end
