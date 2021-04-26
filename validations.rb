# frozen_string_literal: true

module Validations
  def validate_cards_length(hand)
    hand.cards.length > 2
  end

  def validate_cards_count(hand)
    hand.count >= 17
  end

  def validate_balance(player)
    player.bank.balance.positive?
  end

  def validate_deck(deck, length)
    deck.cards.length >= length
  end
end
