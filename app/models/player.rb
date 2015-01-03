class Player < ActiveRecord::Base
	has_many :game_stats

	def update
		UpdateJob.perform_later(self)
	end
end
