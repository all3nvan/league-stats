class Player < ActiveRecord::Base
	has_many :game_stats

	def update
		UpdateJob.perform_later(self)
	end

	def get_stats
		champs_played = $champion_map.select do |id, name|
			self.game_stats.exists?(champion: id)
		end

		champ_stats = champs_played.map do |id, name|
			get_champ_stats(id, name)
		end
		champ_stats.sort_by{ |champ| champ["wins"] }.sort_by{ |champ| champ["games"] }.reverse
	end

	def get_champ_stats(id, name)
		games = self.game_stats.where("champion = ?", id).count
		{"champion" => name,
		 "games" => games,
		 "wins" => self.game_stats.where("champion = ? AND win = ?", id, true).count,
		 "losses" => self.game_stats.where("champion = ? AND win = ?", id, false).count,
		 "kills" => self.game_stats.where("champion = ?", id).average("kills").round(1),
		 "deaths" => self.game_stats.where("champion = ?", id).average("deaths").round(1),
		 "assists" => self.game_stats.where("champion = ?", id).average("assists").round(1),
		 "cs" => self.game_stats.where("champion = ?", id).average("cs").round(1),
		 "gold" => self.game_stats.where("champion = ?", id).average("gold").round(1),
		 "wards_placed" => self.game_stats.where("champion = ?", id).average("wards_placed").round(1),
		 "greens" => self.game_stats.where("champion = ?", id).average("greens").round(1),
		 "pinks" => self.game_stats.where("champion = ?", id).average("pinks").round(1)}
	end
	
end
