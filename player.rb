require_relative 'card'

class Player
	attr_accessor :hand
	attr_reader :name

	def initialize(name)
		@name = name
		@hand = []
	end

	def render_hand
		@hand.each do |card|
			print "[#{card.suit}, #{card.value}]\n"
		end
		
		puts
	end

end