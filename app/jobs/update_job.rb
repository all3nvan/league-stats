class UpdateJob < ActiveJob::Base
  queue_as :default
  require 'open-uri'
  require 'json'

  RIOT_API_URL = "https://na.api.pvp.net/api/lol/na/"
  API_KEY = "f7e80d6f-340b-450a-b2aa-12ba2e8e6da8"

  def perform(player)
    matches = JSON.parse(open("#{RIOT_API_URL}v1.3/game/by-summoner/#{player.summonerId}/recent?api_key=#{API_KEY}").read)
  end
end