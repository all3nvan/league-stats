class PlayersController < ApplicationController

	def index
		@players = Player.all
		@min = params[:minimum].nil? ? 5 : params[:minimum].to_i
		@sorted_winrates = get_winrates(@players, @min)
	end

	def show
		@player = Player.find(params[:id])
		@sorted_stats = @player.get_stats
	end

	def get_winrates(players, min)
		winrates = players.select{ |player| player.game_stats.count >= min }.map do |player|
			{"object" => player,
			 "wins" => player.game_stats.where("win = ?", true).count,
			 "losses" => player.game_stats.where("win = ?", false).count,
			 "winrate" => (player.game_stats.where("win = ?", true).count.to_f /
						  player.game_stats.count * 100).round(1)}
		end
		winrates.sort_by{ |player| player["wins"] }.sort_by{ |player| player["winrate"] }.reverse
	end

end
