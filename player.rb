

class Player

  attr_reader :name, :bank, :count
  attr_accessor :balance, :cards

  def initialize(name = 'Dealer')
    @name = name
    @bank = Bank.new(100)
    @balance = @bank.balance
    @cards = []
  end

  def calculate_count
    @count = cards.reduce(0) do |t, i|
      if %w[J Q K].include?(i.value)
        t += 10
      elsif i.value == 'A' && t <= 10
        t += 11
      elsif i.value == 'A' && t > 10
        t += 11
      else
        t += i.value.to_i
      end
      t
    end
  end
end