# frozen_string_literal: true

require_relative './player'

class User < Player
  TYPE = :user

  def type
    TYPE
  end
end
