module Validations
  def validate_cards_length(player)
    player.cards.length > 2
  end

  def validate_cards_count(player)
    player.count >= 17
  end

  def validate_balance(player)
    player.bank.balance > 0
  end

  def validate_deck(deck, length)
    deck.cards.length >= length
  end
end