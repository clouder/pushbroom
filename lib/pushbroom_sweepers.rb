module PushbroomSweepers
	def self.full_sweep
		User.all.each do |u|
			gmail = connect_to_gmail(u)
			u.brooms.each do |b|
				b.labels.each do |l|
					gmail.label(l).find(:before => b.date).each do |email|
						email.delete!
					end
				end
			end
		end
	end

	def self.manual_sweep(id)
		b = Broom.find(id)
		u = b.user
		gmail = connect_to_gmail(u)
		b.labels.each do |l|
			gmail.label(l).find(:before => b.date).each do |email|
				email.delete!
			end
		end
	end

	private

	def self.connect_to_gmail(u)
		Gmail.connect(
			:xoauth, u.email,
			:token => u.token,
			:secret => u.secret,
			:consumer_key => Pushbroom::Application.config.consumer_key,
			:consumer_secret => Pushbroom::Application.config.consumer_secret
		)
	end
end