# frozen_string_literal: true

class Player
  attr_reader :name, :bank, :count
  attr_accessor :balance

  def initialize(name = 'Dealer')
    @name = name
    @bank = Bank.new(100)
    @balance = @bank.balance
  end
end
