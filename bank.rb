# frozen_string_literal: true

class Bank
  attr_accessor :balance

  def initialize(balance = 0)
    @balance = balance
  end

  def withdraw(value)
    @balance -= value.to_i
  end

  def put_in(value)
    @balance += value.to_i
  end
end
