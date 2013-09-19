ActiveAdmin.register AirPort do

	form do |f|
		f.inputs do
			f.input :name, label: "Nom de l'aéroport"
			f.input :city, label: "Ville"
			f.input :country, label: "Pays"
			f.input :status, label: "Statut de l'aéroport", as: :select, collection: ['ON', 'OFF']
		end
		f.actions
	end

end
