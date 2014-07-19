require_relative 'card'
require 'colorize'

class Player
	attr_accessor :hand
	attr_reader :name

	def initialize(name)
		@name = name
		@hand = []
	end

	def render_hand
		@hand.each do |card|
			if card.suit == :hearts || card.suit == :diamonds
				print "[#{card.suit.to_s.colorize(:red).bold}, #{card.value.to_s.colorize(:red).bold}]\n"
			else
				print "[#{card.suit.to_s.colorize(:black).bold}, #{card.value.to_s.colorize(:black).bold}]\n"
			end
		end

		puts
	end

end