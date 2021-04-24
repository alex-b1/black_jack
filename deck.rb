# frozen_string_literal: true

require_relative './card'

class Deck
  attr_reader :cards

  def initialize
    @cards = get_cards
  end

  private

  def get_cards
    cards = []
    Card.suits.each do |i|
      Card.values.each do |j|
        cards.push(Card.new(i, j))
      end
    end
    cards
  end
end
