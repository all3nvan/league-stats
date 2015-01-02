class Game < ActiveRecord::Base
	has_many :game_stats
	has_many :players, through: :game_stats
end
