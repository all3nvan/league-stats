class UpdateJob < ActiveJob::Base
  queue_as :default
  require 'open-uri'
  require 'json'

  RIOT_API_URL = "https://na.api.pvp.net/api/lol/na/"
  API_KEY = "f7e80d6f-340b-450a-b2aa-12ba2e8e6da8"

  def perform(player)
    response = JSON.parse(open("#{RIOT_API_URL}v1.3/game/by-summoner/#{player.summonerId}/recent?api_key=#{API_KEY}").read)
    games = response["games"]

    games.each do |game|
    	if inhouse?(game) && !in_database?(game)
        inhouseGame = JSON.parse(open("#{RIOT_API_URL}v2.2/match/#{game["gameId"]}").read)
    		player.game_stats.create(game_id: inhouseGame["gameId"])
    	end
    end
  end

  def inhouse?(game)
    (game["gameType"] == "CUSTOM_GAME") && (game["fellowPlayers"].count == 10)
  end

  def in_database?(game)
    Game.exists?(game_id: game["gameId"])
  end
end
