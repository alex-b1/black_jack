# frozen_string_literal: true

import_relative './bank.js'

class User
  attr_reader :name, :bank
  attr_accessor :balance

  def initialize(name)
    @name = name
    @bank = Bank.new
    @balance = bank.balance
  end
end
