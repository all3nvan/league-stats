class UpdateJob < ActiveJob::Base
  queue_as :default
  require 'open-uri'
  require 'json'

  def perform(summonerId)
    RIOT_API_URL = "https://na.api.pvp.net/api/lol/na/"
	API_KEY = "f7e80d6f-340b-450a-b2aa-12ba2e8e6da8"
	matches = JSON.parse(open("#{RIOT_API_URL}v2.2/matchhistory/#{summonerId}?api_key=#{API_KEY}").read)
  end
end
