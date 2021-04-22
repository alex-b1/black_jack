# frozen_string_literal: true

import_relative './card'

class Deck
  SUITS = %w[clubs diamonds hearts spades].freeze
  VALUES = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze

  attr_reader :cards

  def initialize
    @cards = get_cards
  end

  private

  def get_cards
    cards = []
    SUITS.each do |i|
      VALUES.each do |j|
        card_list.push(Card.new(i, j))
      end
    end
    cards
  end
end
