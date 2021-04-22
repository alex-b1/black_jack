# frozen_string_literal: true

import_relative './User'
import_relative './Dealer'
import_relative './Helper'

class Game
  include Helper
  attr_reader :user, :dealer

  def init
    print 'Ведите ваше имя: '
    name = string
    @user = User.new(name)
    @dealer = Dealer.new(name)
    start
  end

  def start; end
end
