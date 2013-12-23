ActiveAdmin.register User, as: "Stats" do
	
	config.clear_sidebar_sections!

	index do
		table do

			tr do
				th "from"
				th "to"
				th "Nb inscrits"
				th "Nb demandes parking"
				th "Nb RDV pris"
			end

			date = Time.zone.local(2013, 9, 23, 0, 0, 0) # Start date
			end_date = Time.zone.now

			while date < end_date
				condition = "created_at >= '#{date - 7.days}' AND created_at < '#{date}'"
				count_users = User.where(condition).count
				count_travels = Travel.where(condition).count
				count_rdv = Travel.where(condition << " AND rdv IS NOT NULL").count
				
				tr do
					td date - 7.days
					td date
					td count_users
					td count_travels
					td count_rdv
				end

				date = date + 7.days
			end
		end
	end

end