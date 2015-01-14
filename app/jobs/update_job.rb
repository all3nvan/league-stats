class UpdateJob < ActiveJob::Base
  queue_as :default
  require 'open-uri'
  require 'json'

  RIOT_API_URL = "https://na.api.pvp.net/api/lol/na/"
  #API_KEY = "f7e80d6f-340b-450a-b2aa-12ba2e8e6da8"
  API_KEY = APP_CONFIG["API_KEY"]
  RUN_EVERY = 1.hour

  def perform(player)
    sleep(11)
    numberOfRequests = 0

    response = JSON.parse(open("#{RIOT_API_URL}v1.3/game/by-summoner/#{player.summonerId}/recent?api_key=#{API_KEY}").read)
    numberOfRequests = rate_limit_check(numberOfRequests)
    games = response["games"]

    games.each do |game|
    	if ( inhouse?(game) && !in_database?(game) )
        # game = old endpoint
        # inhouseGame = new endpoint
        inhouseGame = JSON.parse(open("#{RIOT_API_URL}v2.2/match/#{game["gameId"]}?api_key=#{API_KEY}").read)
        numberOfRequests = rate_limit_check(numberOfRequests)
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
            numberOfRequests = rate_limit_check(numberOfRequests)
            new_player = Player.create(summonerId: otherPlayer["summonerId"],
                                       name: name[otherPlayer["summonerId"].to_s])
            add_game_stats(new_player, otherPlayer["championId"], inhouseGame)
          end
        end
    	end
    end

    self.class.set(wait: RUN_EVERY).perform_later(player)
  end

  def inhouse?(game)
    (game["gameType"] == "CUSTOM_GAME") && (game["fellowPlayers"].count == 9)
  end

  def in_database?(game)
    Game.exists?(game_id: game["gameId"])
  end

  def add_game(game)
    blue_bans = game["teams"][0]["bans"].map{ |ban| ban["championId"]}
    purple_bans = game["teams"][1]["bans"].map{ |ban| ban["championId"]}

    Game.create(game_id: game["matchId"],
                blue_1: blue_bans[0],
                blue_2: blue_bans[1],
                blue_3: blue_bans[2],
                purple_1: purple_bans[0],
                purple_2: purple_bans[1],
                purple_3: purple_bans[2])
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

  def rate_limit_check(requests)
    requests += 1
    if requests == 10
      sleep(11)
      requests = 0
    end
    requests
  end
end
