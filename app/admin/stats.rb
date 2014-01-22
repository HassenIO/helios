ActiveAdmin.register User, as: "Stats" do
	
	config.clear_sidebar_sections!

	index do
		h3 "Statistiques, mois par mois"
		table do

			tr do
				th "from"
				th "to"
				th "Nb inscrits"
				th "Nb demandes parking"
				th "Nb RDV pris"
			end

			date = Time.zone.local(2013, 9, 1, 0, 0, 0) # Start date
			end_date = Time.zone.now

			while date < end_date
				condition = "created_at >= '#{date}' AND created_at < '#{date + 1.month}'"
				count_users = User.where(condition).count
				count_travels = Travel.where(condition).count
				count_rdv = Travel.where(condition << " AND rdv IS NOT NULL").count
				
				tr do
					td date
					td date + 1.month - 1.day
					td count_users
					td count_travels
					td count_rdv
				end

				date = date + 1.month
			end
		end


		days = 0
		Travel.all.each { |t| days += (t.arrival.to_date - t.departure.to_date).to_i + 1 }

		h3 "Nombre de jours de parking demandés :  jours"


		h3 "Répartition des durées de parking"

		days_7 = 0
		days_15 = 0
		days_30 = 0
		days_999 = 0
		Travel.all.each do |t|
			d = (t.arrival.to_date - t.departure.to_date).to_i + 1
			days_7 += 1 if d <= 7
			days_15 += 1 if (d > 7 && d <= 15)
			days_30 += 1 if (d > 15 && d <= 30)
			days_999 += 1 if (d > 30)
		end
		count = Travel.count

		ul do
			li "7 jours et moins : #{days_7} (#{ (days_7*100/count).ceil }%)"
			li "entre 8 et 15 jours : #{days_15} (#{ (days_15*100/count).ceil }%)"
			li "entre 16 et 30 jours : #{days_30} (#{ (days_30*100/count).ceil }%)"
			li "strictement plus de 30 jours : #{days_999} (#{ (days_999*100/count).ceil }%)"
		end

		br
		h3 "Répartition sur l'anticipations des demandes de parking"

		days_3 = 0
		days_7 = 0
		days_15 = 0
		days_30 = 0
		days_999 = 0
		Travel.all.each do |t|
			d = (t.arrival.to_date - t.departure.to_date).to_i + 1
			days_3 += 1 if d <= 3
			days_7 += 1 if (d > 3 && d <= 7)
			days_15 += 1 if (d > 7 && d <= 15)
			days_30 += 1 if (d > 15 && d <= 30)
			days_999 += 1 if (d > 30)
		end

		ul do
			li "3 jours et moins : #{days_3} (#{ (days_3*100/count).ceil }%)"
			li "entre 4 et 7 jours : #{days_7} (#{ (days_7*100/count).ceil }%)"
			li "entre 8 et 15 jours : #{days_15} (#{ (days_15*100/count).ceil }%)"
			li "entre 16 et 30 jours : #{days_30} (#{ (days_30*100/count).ceil }%)"
			li "strictement plus de 30 jours : #{days_999} (#{ (days_999*100/count).ceil }%)"
		end


		br
		h3 "Répartition de l'âge des véhicules"

		this_year = Date.today.year
		count_cars = Car.count
		cars_new = Car.where("year >= #{this_year - 5}").count
		cars_old = Car.where("year <= #{this_year - 9}").count

		r_new = (cars_new*100/count_cars).ceil
		r_old = (cars_old*100/count_cars).ceil

		ul do
			li "Voitures entre #{this_year - 5} (inclus) et maintenant : #{cars_new} (#{r_new}%)"
			li "Voitures entre #{this_year - 8} (inclus) et #{this_year - 6} (inclus) : #{count_cars - cars_new - cars_old} (#{ 100 - r_new - r_old }%)"
			li "Voitures plus anciennes que #{this_year - 9} (inclus) : #{cars_old} (#{r_old}%)"
		end

	end

end