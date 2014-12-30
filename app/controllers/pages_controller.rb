class PagesController < ApplicationController
  def home
  	Player.first.get_match_history(23472148)
  end
end
