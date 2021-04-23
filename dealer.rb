# frozen_string_literal: true

require_relative './bank.js'
require_relative './player.js'

class Dealer < Player
  TYPE = :dealer

  def type
    TYPE
  end
end
