# frozen_string_literal: true

require_relative './player'

class Dealer < Player
  TYPE = :dealer

  def type
    TYPE
  end
end
