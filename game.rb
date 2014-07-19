require_relative 'player'
require_relative 'deck'

class InvalidMoveError < StandardError
end

class Game

	def initialize
		@players = []
		4.times do |num|
			@players << Player.new("Player #{num}")
		end

		@stock_pile = Deck.new.shuffle!
		@discard_pile = []
		@turn = 0

		5.times do |num|
			@players.each do |player|
				player << @stock_pile.pop
			end
		end

		@discard_pile << @stock_pile.pop

	end

	def play
		until self.over?
			current_player = @players[@turn % 4]
			puts "#{current_player.name.capitalize}'s turn."
			puts "#{[@discard_pile.last.suit, @discard_pile.last.value} was the last card."
			puts "Your current cards are: "
			current_player.hand.render

			begin
				card_response = self.prompt_for_card(current_player)

				unless @discard_pile.last.can_accept?(card_response[0], card_response[1])
					raise InvalidMoveError.new("You can't play that card.  Try again")
				end
			rescue InvalidMoveError => error 
				puts error.message
				retry
			end



	end

	def prompt_for_card(player)
		puts "Choose a card to discard (suit first, then comma, then card value)"
		response = gets.chomp
		card_response = self.parse(response)

		if !Deck::SUITS.include?(card_response[0]) || !Deck::VALUES.include?(card_response[1])
			raise InvalidMoveError.new("That card does not exist.  Try again.")
		elsif player.hand.none? { |card| card.can_accept?(card_response[0]) || card.can_accept?(card_response[1]) }
			raise InvalidMoveError.new("You don't have that card.  Try again.")
		end

		card_response
	end

	def over?
		return true if @players.any? { |player| player.hand.empty? }

		false
	end

	def parse(response)
		output_array = response.split(",").map { |x| x.strip.to_sym }
	end

end