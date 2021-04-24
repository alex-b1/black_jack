# frozen_string_literal: true

class Hand
  attr_accessor :user, :dealer

  def initialize(user, dealer)
    @user = { player: user, cards: [], count: 0 }
    @dealer = { player: dealer, cards: [], count: 0 }
  end

  def add_card(player, card)
    @user[:cards].concat(card) if player == :user
    @dealer[:cards].concat(card) if player == :dealer
  end

  def check_length
    @user[:cards].length == 3 && @dealer[:cards].length == 3
  end

  def calculate_count
    [@user, @dealer].each do |i|
      i[:count] = i[:cards].reduce(0) do |t, j|
        t += if %w[J Q K].include?(j.value)
               10
             elsif j.value == 'A' && t <= 10
               11
             elsif j.value == 'A' && t > 10
               1
             else
               j.value.to_i
             end
        t
      end
    end
  end
end
