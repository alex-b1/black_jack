# frozen_string_literal: true

class Hand
  attr_accessor :cards, :count

  def initialize
    @cards = []
    @count = 0
  end

  def add_cards(item)
    @cards.concat(item)
  end

  def calculate_count
    @count = @cards.reduce(0) do |t, j|
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
