# frozen_string_literal: true

require_relative './validations'
require_relative './interface'
require_relative './dealer'
require_relative './helper'
require_relative './deck'
require_relative './user'
require_relative './bank'
require_relative './hand'

class Game
  include Validations
  include Helper

  MAX_COUNT = 21

  attr_reader :user, :dealer, :deck, :bank, :hand

  def initialize
    @command_list = {
      1 => { title: Interface.task(1), command: proc { pass } },
      2 => { title: Interface.task(2), command: proc { |i| add_card i } },
      3 => { title: Interface.task(3), command: proc { open_cards } },
    }
  end

  def init
    Interface.name
    name = string
    @user = User.new(name)
    @dealer = Dealer.new
    @deck = Deck.new
    @deck.cards.shuffle!
    @bank = Bank.new

    start
  end

  def start
    loop do
      @hand = Hand.new(@user, @dealer)
      issue_cards
      place_bet
      Interface.show_cards(hand)

      loop do
        break if check_cards_length
        break if user_actions == 3
        dealer_actions
        Interface.show_cards(hand)
      rescue StandardError => e
        Interface.error(e)
        continue
      end

      calculate_result
      break if Interface.repeat
      clear

      rescue StandardError => e
        Interface.error(e)
        init if Interface.replay
        break
    end
  end

  def check_cards_length
    hand.check_length
  end

  def user_actions
    show_tasks
    task_number = task
    @command_list[task_number][:command].call(user)
    task_number
  end

  def dealer_actions
    if validate_cards_count hand.dealer
      pass
    else
      add_card dealer
    end
  end

  def show_tasks
    Interface.action
    @command_list.each { |k, v| puts "#{k} - #{v[:title]}" }
  end

  def issue_cards
    if validate_deck(@deck, 4)
      hand.user[:cards].concat(@deck.cards.slice!(0, 2))
      hand.dealer[:cards].concat(@deck.cards.slice!(0, 2))
      hand.calculate_count
    else
      raise Interface.no_card
    end
  end

  def place_bet
    if validate_balance user
      user.bank.withdraw(10)
    else
      raise Interface.no_user_money
    end

    if validate_balance dealer
      dealer.bank.withdraw(10)
    else
      raise Interface.no_dealer_money
    end

    bank.put_in(20)
  end

  def pass
    true
  end

  def add_card(player)
    hand_player = hand.send player.type
    unless validate_cards_length(hand_player)
      if validate_deck(@deck, 1)
        card = @deck.cards.slice!(0, 1)
        hand.add_card(player.type, card)
      else
        raise Interface.no_cards
      end
    end
    hand.calculate_count
  end

  def open_cards
    Interface.count hand.user
    Interface.count hand.dealer
    [hand.user[:count], hand.dealer[:count]]
  end

  def calculate_result
    user_count, dealer_count = open_cards
    if user_count > MAX_COUNT
      Interface.defeat
      dealer.bank.put_in(20)
    elsif user_count == dealer_count
      Interface.draw
      user.bank.put_in(10)
      dealer.bank.put_in(10)
    elsif (user_count > dealer_count) || (dealer_count > MAX_COUNT)
      Interface.win
      user.bank.put_in(10)
    else
      Interface.defeat
      dealer.bank.put_in(20)
    end
  end
end

game = Game.new
game.init
