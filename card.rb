# frozen_string_literal: true

class Card
  SUITS = %w[clubs diamonds hearts spades].freeze
  VALUES = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze

  attr_reader :suit, :value

  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def self.suits
    SUITS
  end

  def self.values
    VALUES
  end
end
