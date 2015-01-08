class PlayersController < ApplicationController

	def index
		@players = Player.all
		@sorted_winrates = get_winrates(@players)
	end

	def show
		@player = Player.find(params[:id])
		@sorted_champ_stats = get_champ_stats(@player)
	end

	def get_winrates(players)
		winrates = players.map do |player|
			{"object" => player,
			 "wins" => player.game_stats.where("win = ?", true).count,
			 "losses" => player.game_stats.where("win = ?", false).count,
			 "winrate" => (player.game_stats.where("win = ?", true).count.to_f /
						  player.game_stats.count * 100).round(1)}
		end
		winrates.sort_by{ |player| player["winrate"] }.reverse
	end

	def get_champ_stats(player)
		champs_played = $champion_map.select do |id, name|
			player.game_stats.exists?(champion: id)
		end

		champ_stats = champs_played.map do |id, name|
			games = player.game_stats.where("champion = ?", id).count
			{"champion" => name,
			 "games" => games,
			 "wins" => player.game_stats.where("champion = ? AND win = ?", id, true).count,
			 "losses" => player.game_stats.where("champion = ? AND win = ?", id, false).count,
			 "kills" => player.game_stats.where("champion = ?", id).average("kills").round(1),
			 "deaths" => player.game_stats.where("champion = ?", id).average("deaths").round(1),
			 "assists" => player.game_stats.where("champion = ?", id).average("assists").round(1),
			 "cs" => player.game_stats.where("champion = ?", id).average("cs").round(1),
			 "gold" => player.game_stats.where("champion = ?", id).average("gold").round(1),
			 "wards_placed" => player.game_stats.where("champion = ?", id).average("wards_placed").round(1),
			 "greens" => player.game_stats.where("champion = ?", id).average("greens").round(1),
			 "pinks" => player.game_stats.where("champion = ?", id).average("pinks").round(1)}
		end
		champ_stats.sort_by{ |champ| champ["games"] }.reverse
	end

end
