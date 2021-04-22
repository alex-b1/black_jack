# frozen_string_literal: true

require_relative './User'
require_relative './Dealer'
require_relative './Helper'
require_relative './Deck'
require_relative './bank'

class Game
  include Helper
  attr_reader :user, :dealer, :deck, :bank, :balance

  def init
    print 'Ведите ваше имя: '
    name = string
    @user = User.new(name)
    @dealer = Dealer.new(name)
    @deck = Deck.new
    @deck.shuffle!
    @bank = Bank.new
    @balance = bank.balance
    start
  end

  def start
    issue_cards
  end

  def issue_cards
    user.cards = @deck.slice!(0, 2)
    user.calculate_count
    dealer.cards = @deck.slice!(0, 2)
    dealer.calculate_count
  end

  def place_bet
    user.bank.withdraw(10)
    dealer.bank.withdraw(10)

    bank.balance.put_in(20)
  end

  def get_cards

  end
end
