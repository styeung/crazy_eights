require_relative 'player'

class Game

	def initialize
		@players = []
		4.times do |num|
			@players << Player.new("Player #{num}")
		end

		@stock_pile = Deck.new.shuffle!
		@discard_pile = []

		5.times do |num|
			@players.each do |player|
				player << @stock_pile.pop
			end
		end

		@discard_pile << @stock_pile.pop

	end

	

end