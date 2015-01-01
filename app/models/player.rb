class Player < ActiveRecord::Base
	def update
		UpdateJob.perform_later(self)
	end
end
