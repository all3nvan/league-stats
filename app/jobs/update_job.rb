class UpdateJob < ActiveJob::Base
  queue_as :default
  require 'open-uri'
  require 'json'

  def perform(summonerId)
	matches = JSON.parse(open("https://na.api.pvp.net/api/lol/na/v2.2/matchhistory/#{summonerId}?api_key=f7e80d6f-340b-450a-b2aa-12ba2e8e6da8").read)
  end
end
