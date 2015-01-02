class Player < ActiveRecord::Base
	has_many :game_stats
	has_many :games, through: :game_stats

	def update
		UpdateJob.perform_later(self)
	end
end
