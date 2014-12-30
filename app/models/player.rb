class Player
  include Mongoid::Document
  field :name, type: String
  field :summonerId, type: Integer

  def get_match_history(id)
  	UpdateJob.set(wait: 5.minutes).perform_later(id)
  end
end
