class Card
	attr_accessor :suit, :value

	def initialize(suit, value)
		@suit = suit
		@value = value
	end

	def can_accept?(suit, value)
		return true if self.suit == suit || self.value == value || value == :eight

		false
	end

	def is_same?(suit, value)
		return true if self.suit == suit && self.value == value

		false
	end

end