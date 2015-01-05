class UpdateJob < ActiveJob::Base
  queue_as :default
  require 'open-uri'
  require 'json'

  RIOT_API_URL = "https://na.api.pvp.net/api/lol/na/"
  API_KEY = "f7e80d6f-340b-450a-b2aa-12ba2e8e6da8"

  def perform(player)
    sleep(11)
    numberOfRequests = 0

    response = JSON.parse(open("#{RIOT_API_URL}v1.3/game/by-summoner/#{player.summonerId}/recent?api_key=#{API_KEY}").read)
    games = response["games"]
    numberOfRequests += 1

    games.each do |game|
    	if ( inhouse?(game) && !in_database?(game) )
        # game = old endpoint
        # inhouseGame = new endpoint
        inhouseGame = JSON.parse(open("#{RIOT_API_URL}v2.2/match/#{game["gameId"]}?api_key=#{API_KEY}").read)
        add_game(inhouseGame)

        # add tracked player's stats
        add_game_stats(player, game["championId"], inhouseGame)

        # add other players' stats
        game["fellowPlayers"].each do |otherPlayer|
          if Player.exists?(summonerId: otherPlayer["summonerId"])
            add_game_stats(Player.find_by(summonerId: otherPlayer["summonerId"]),
                           otherPlayer["championId"],
                           inhouseGame)
          else
            name = JSON.parse(open("#{RIOT_API_URL}v1.4/summoner/#{otherPlayer["summonerId"]}/name?api_key=#{API_KEY}").read)
            new_player = Player.create(summonerId: otherPlayer["summonerId"],
                                       name: name[otherPlayer["summonerId"].to_s])
            add_game_stats(new_player, otherPlayer["championId"], inhouseGame)

            numberOfRequests += 1
          end
        end

        numberOfRequests += 1
    	end

      if numberOfRequests == 10
        sleep(11)
        numberOfRequests = 0
      end
    end
  end

  def inhouse?(game)
    (game["gameType"] == "CUSTOM_GAME") && (game["fellowPlayers"].count == 9)
  end

  def in_database?(game)
    Game.exists?(game_id: game["gameId"])
  end

  def add_game(game)
    Game.create(game_id: game["matchId"])
    # need bans and other info
  end

  def add_game_stats(player, champ, game)
    # match player with correct element of participants array using champion id.
    stats = game["participants"].select{ |participant| participant["championId"] == champ}[0]
    player.game_stats.create(game_id: game["matchId"],
                             champion: stats["championId"],
                             kills: stats["stats"]["kills"],
                             deaths: stats["stats"]["deaths"],
                             assists: stats["stats"]["assists"],
                             cs: stats["stats"]["minionsKilled"] +
                                 stats["stats"]["neutralMinionsKilled"],
                             gold: stats["stats"]["goldEarned"],
                             greens: stats["stats"]["sightWardsBoughtInGame"],
                             pinks: stats["stats"]["visionWardsBoughtInGame"],
                             wards_placed: stats["stats"]["wardsPlaced"],
                             win: stats["stats"]["winner"],
                             duration: game["matchDuration"],
                             team: game["teamId"])
  end
end
