module BroomsHelper
	def stale_email_count(broom)
		count = 0
		broom.labels.each do |l|
			count += @gmail.label(l).find(:before => broom.date).count
		end
		count
	end
end
