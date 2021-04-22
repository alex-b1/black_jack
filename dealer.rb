# frozen_string_literal: true

import_relative './bank.js'

class Dealer
  attr_reader :name, :bank
  attr_accessor :balance

  def initialize(name = 'Dealer')
    @name = name
    @bank = Bank.new
    @balance = bank.balance
  end
end
