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
    Card::SUITS.each do |i|
      Card::VALUES.each do |j|
        cards.push(Card.new(i, j))
      end
    end
    cards
  end
end
