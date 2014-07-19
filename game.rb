require_relative 'player'
require_relative 'deck'
require 'colorize'

class InvalidMoveError < StandardError
end

class Game

	def initialize
		@players = []
		4.times do |num|
			@players << Player.new("Player #{num + 1}")
		end

		@stock_pile = Deck.new.shuffle!
		@discard_pile = []
		@turn = 0

		5.times do |num|
			@players.each do |player|
				player.hand << @stock_pile.pop
			end
		end

		@discard_pile << @stock_pile.pop

	end

	def play
		until self.over?
			puts
			current_player = @players[@turn % 4]
			last_card = @discard_pile.last
			puts "#{current_player.name.capitalize}'s turn."
			if last_card.suit == :hearts || last_card.suit == :diamonds
				puts "[#{last_card.suit.to_s.colorize(:red).bold}, #{last_card.value.to_s.colorize(:red).bold}] was the last card."
			else
				puts "[#{last_card.suit.to_s.colorize(:black).bold}, #{last_card.value.to_s.colorize(:black).bold}] was the last card."
			end

			puts "Your current cards are: "
			current_player.render_hand

			while current_player.hand.none? { |card| @discard_pile.last.can_accept?(card.suit, card.value) }
				puts "You have no valid cards.  Please draw."
				self.draw_card(current_player)
				current_player.render_hand
			end

			begin
				card_response = self.prompt_for_card(current_player)

				unless @discard_pile.last.can_accept?(card_response[0], card_response[1])
					raise InvalidMoveError.new("You can't play that card.  Try again")
				end
			rescue InvalidMoveError => error 
				puts error.message
				retry
			end

			current_player.hand.each do |card|
				if card.is_same?(card_response[0], card_response[1])
					self.discard_card(current_player, card)
				end
			end

			if self.over?
				puts "#{current_player.name.capitalize} is the winner!"
			end

			@turn += 1
		end
	end

	def prompt_for_card(player)
		puts
		puts "Choose a card to discard (suit first, then comma, then card value)"
		response = gets.chomp
		card_response = self.parse(response)

		if !Deck::SUITS.include?(card_response[0]) || !Deck::VALUES.include?(card_response[1])
			raise InvalidMoveError.new("That card does not exist.  Try again.")
		elsif player.hand.none? { |card| card.is_same?(card_response[0], card_response[1]) }
			raise InvalidMoveError.new("You don't have that card.  Try again.")
		end

		card_response
	end

	def draw_card(player)
		player.hand << @stock_pile.pop
	end

	def discard_card(player, card)
		if card.value == :eight
			suit_response = self.prompt_for_wild_card_suit
			@discard_pile << Card.new(suit_response, :wild)
		else
			@discard_pile << card
		end

		player.hand -= [card]
	end

	def prompt_for_wild_card_suit
		begin
			puts "You played a wild card.  Which suit do you want to set?"
			suit_response = gets.chomp.to_sym

			if !Deck::SUITS.include?(suit_response)
				raise InvalidMoveError.new("That suit does not exist.  Try again.")
			end
		rescue InvalidMoveError => error
			puts error.message
			retry
		end

		suit_response
	end

	def over?
		return true if @players.any? { |player| player.hand.empty? }

		false
	end

	def parse(response)
		output_array = response.split(",").map { |x| x.strip.to_sym }
	end

end