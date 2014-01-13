ActiveAdmin.register_page "Dashboard" do

	menu :priority => 1, :label => proc { I18n.t("active_admin.dashboard") }

	content :title => proc { I18n.t("active_admin.dashboard") } do


		# Here is an example of a simple dashboard with columns and panels.
		#
		columns do
			column do
				panel "Pending travels" do
					table_for Travel.where("departure > '#{Time.now}' AND status = #{Travel::STATUS[:pending]}").order('departure asc').each do |travel|
						column(:id) { |travel| link_to "Travel ##{travel.id}", admin_travel_path(travel) }
						column(:airPort) { |travel| travel.airPort.name }
						column(:car) { |travel| link_to "#{travel.car.brand} #{travel.car.model} (#{travel.car.year})", user_travel_path( travel.user, travel ) }
						column(:departure, sortable: :departure)
						column(:arrival)
						column(:created_at, sortable: :created_at)
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
