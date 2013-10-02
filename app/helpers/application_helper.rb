module ApplicationHelper
	
	def flash_class(level)
		case level
			when :notice then "alert alert-info"
			when :success then "alert alert-success"
			when :error then "alert alert-error"
			when :alert then "alert alert-error"
		end
	end

	# Convert System datetime (YYYY-mm-dd HH:MM:SS) to human format (dd/mm/YYYY - HH:MM)
	def system_to_homan_datetime datetime
		datetime.strftime "%d/%m/%Y %H:%M"
	end

	# Convert System date (YYYY-mm-dd) to human format (dd/mm/YYYY)
	def system_to_human_date date
		date.blank? ? nil : date.strftime( "%d/%m/%Y" )
	end
	
end
