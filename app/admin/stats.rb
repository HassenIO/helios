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

		h3 "Nombre de jours de parking demandés : #{days} jours"


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
			li "Entre 8 et 15 jours : #{days_15} (#{ (days_15*100/count).ceil }%)"
			li "Entre 16 et 30 jours : #{days_30} (#{ (days_30*100/count).ceil }%)"
			li "Strictement plus de 30 jours : #{days_999} (#{ (days_999*100/count).ceil }%)"
		end

		br
		h3 "Répartition sur l'anticipations des demandes de parking"

		days_3 = 0
		days_7 = 0
		days_15 = 0
		days_30 = 0
		days_999 = 0
		Travel.all.each do |t|
			d = (t.departure.to_date - t.created_at.to_date).to_i + 1
			days_3 += 1 if d <= 3
			days_7 += 1 if (d > 3 && d <= 7)
			days_15 += 1 if (d > 7 && d <= 15)
			days_30 += 1 if (d > 15 && d <= 30)
			days_999 += 1 if (d > 30)
		end

		ul do
			li "3 jours et moins : #{days_3} (#{ (days_3*100/count).ceil }%)"
			li "Entre 4 et 7 jours : #{days_7} (#{ (days_7*100/count).ceil }%)"
			li "Entre 8 et 15 jours : #{days_15} (#{ (days_15*100/count).ceil }%)"
			li "Entre 16 et 30 jours : #{days_30} (#{ (days_30*100/count).ceil }%)"
			li "Strictement plus de 30 jours : #{days_999} (#{ (days_999*100/count).ceil }%)"
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



		br
		h3 "Requêtes sur l'API"

		count_requests = ApiMgt.count
		requests = ApiMgt.group(:affiliate_id, :airport_id).count
		count_requests_by_aa = {}

		ul do
			requests.each do |request, count|
				count_requests_by_aa["#{request[0]}#{request[1]}"] = count
				li "#{request[0]} à #{ApiMgt::AIRPORT[request[1]]} : #{count} requêtes ( #{ sprintf "%.2f", 100 * count / count_requests }% )"
			end
			li "Total : #{count_requests} requêtes"
		end


		br
		h3 "Clics à travers l'API par affilié"

		requests = ApiMgt.group(:affiliate_id, :airport_id).sum(:nb_clicks)
		total_clicks = 0

		ul do
			requests.each do |request, count|
				total_requests_for_this_aa = count_requests_by_aa["#{request[0]}#{request[1]}"]
				li "#{request[0]} à #{ApiMgt::AIRPORT[request[1]]} : #{count} clics (#{ sprintf "%.2f", 100 * count / total_requests_for_this_aa }%)"
				total_clicks += count
			end
			li "Total : #{total_clicks} clics"
		end


		br
		h3 "Anticipation des recherches via l'API"

		days_2 = 0
		days_7 = 0
		days_15 = 0
		days_30 = 0
		days_60 = 0
		days_999 = 0
		ApiMgt.all.each do |r|
			d = ((Time.strptime( "#{r.pickup_date} #{r.pickup_time}", "%Y-%m-%d %H:%M" ) - r.created_at)/1.day).ceil
			days_2 += 1 if d <= 2
			days_7 += 1 if (d > 2 && d <= 7)
			days_15 += 1 if (d > 7 && d <= 15)
			days_30 += 1 if (d > 15 && d <= 30)
			days_60 += 1 if (d > 30 && d <= 60)
			days_999 += 1 if (d > 60)
		end

		ul do
			li "2 jours et moins : #{days_2} (#{ (100 * days_2 / count_requests).ceil }%)"
			li "Entre 3 et 7 jours : #{days_7} (#{ (100 * days_7 / count_requests).ceil }%)"
			li "Entre 8 et 15 jours : #{days_15} (#{ (100 * days_15 / count_requests).ceil }%)"
			li "Entre 16 et 30 jours : #{days_30} (#{ (100 * days_30 / count_requests).ceil }%)"
			li "Entre 31 et 60 jours : #{days_60} (#{ (100 * days_60 / count_requests).ceil }%)"
			li "Strictement plus de 60 jours : #{days_999} (#{ (100 * days_999 / count_requests).ceil }%)"
		end


		br
		h3 "Répartition des durée de locations via l'API"

		days_1 = 0
		days_2 = 0
		days_3 = 0
		days_4 = 0
		days_7 = 0
		days_10 = 0
		days_15 = 0
		days_21 = 0
		days_999 = 0
		ApiMgt.all.each do |r|
			d = ((Time.strptime( "#{r.dropoff_date} #{r.dropoff_time}", "%Y-%m-%d %H:%M" ) - Time.strptime( "#{r.pickup_date} #{r.pickup_time}", "%Y-%m-%d %H:%M" ))/1.day).ceil
			days_1 += 1 if d <= 1
			days_2 += 1 if d == 2
			days_3 += 1 if d == 3
			days_4 += 1 if d == 4
			days_7 += 1 if (d > 4 && d <= 7)
			days_10 += 1 if (d > 7 && d <= 10)
			days_15 += 1 if (d > 10 && d <= 15)
			days_21 += 1 if (d > 15 && d <= 21)
			days_999 += 1 if d > 21
		end

		ul do
			li "1 jour et moins : #{days_1} (#{ (100 * days_1 / count_requests).ceil }%)"
			li "2 jours et moins : #{days_2} (#{ (100 * days_2 / count_requests).ceil }%)"
			li "3 jours et moins : #{days_3} (#{ (100 * days_3 / count_requests).ceil }%)"
			li "4 jours et moins : #{days_4} (#{ (100 * days_4 / count_requests).ceil }%)"
			li "Entre 5 et 7 jours : #{days_7} (#{ (100 * days_7 / count_requests).ceil }%)"
			li "Entre 8 et 10 jours : #{days_10} (#{ (100 * days_10 / count_requests).ceil }%)"
			li "Entre 11 et 15 jours : #{days_15} (#{ (100 * days_15 / count_requests).ceil }%)"
			li "Entre 16 et 21 jours : #{days_21} (#{ (100 * days_21 / count_requests).ceil }%)"
			li "Strictement plus de 21 jours : #{days_999} (#{ (100 * days_999 / count_requests).ceil }%)"
		end

	end

end