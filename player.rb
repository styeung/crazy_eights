require_relative 'card'

class Player
	attr_accessor :hand
	attr_reader :name

	def initialize(name)
		@name = name
		@hand = []
	end


end