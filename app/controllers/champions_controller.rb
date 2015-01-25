class ChampionsController < ApplicationController

	def index
		@champs_contested = $champion_map.select do |id, name|
			GameStat.exists?(champion: id)
		end
		@sorted_champ_stats = get_all_champ_stats(@champs_contested)
	end

	def show
		@champion = Champion.find(params[:id])
		@sorted_player_stats = get_player_stats(@champion)
	end

	def get_all_champ_stats(champs)
		champ_stats = champs.map do |id, name|
			times_banned = Game.where("blue_1 = ? OR
									   blue_2 = ? OR
									   blue_3 = ? OR
									   purple_1 = ? OR
									   purple_2 = ? OR
									   purple_3 = ?", id, id, id, id, id, id).count
			times_picked = GameStat.where("champion = ?", id).count
			wins = GameStat.where("champion = ? AND win = ?", id, true).count
			{"champion" => name,
			 "contests" => times_banned + times_picked,
			 "contest_rate" => ( (times_banned + times_picked).to_f / Game.count * 100).round(1),
			 "picks" => times_picked,
			 "bans" => times_banned,
			 "winrate" => (wins.to_f / times_picked * 100).round(1),
			 "wins" => wins,
			 "losses" => GameStat.where("champion = ? AND win = ?", id, false).count}
		end
		champ_stats.sort_by{ |champ| champ["contests"] }.reverse
	end

	def get_player_stats(champ)
=begin
		player_stats = []
		Player.find_each do |player|
			if player.game_stats.exists?(champion: champ.champ_id)
				player_stats << [player.name, player.get_champ_stats(champ.champ_id, champ.name)]
			end
		end
		player_stats.sort_by{ |player| player[1]["wins"] }.
					 sort_by{ |player| player[1]["games"] }.reverse
=end
		ids = GameStat.where("champion = ?", champ.champ_id).select(:id, :player_id).group(:player_id).sum(:id)
		player_stats = Array.new
		ids.each_key do |id|
			player = Player.find(id)
			player_stats << [player.name, player.get_champ_stats(champ.champ_id, champ.name)]
		end
		player_stats.sort_by{ |player| player[1]["wins"] }.
					 sort_by{ |player| player[1]["games"] }.reverse
	end

end
