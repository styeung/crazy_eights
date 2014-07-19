require_relative 'card'

class Deck
	SUITS = [:spades, :hearts, :clubs, :diamonds]

	VALUES = [
	:ace,
    :two,
    :three ,
    :four,
    :five,
    :six,
    :seven,
    :eight,
    :nine,
    :ten,
    :jack,
    :queen,
    :king
  	]

  def self.return_all_cards
		output_array = []

		SUITS.each do |suit|
			VALUES.each do |value|
				output_array << Card.new(suit, value)
			end
		end

		output_array
	end

	def initialize
		@cards = Deck.return_all_cards
	end

	def shuffle!
		@cards.shuffle!
	end
end