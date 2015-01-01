class Player < ActiveRecord::Base
	#attr_accessor :name, :summonerId
	def update
		UpdateJob.perform_later(self.summonerId)
	end
end
