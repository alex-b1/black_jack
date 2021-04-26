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

  attr_reader :user, :dealer, :deck, :bank, :user_hand, :dealer_hand

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
      @user_hand = Hand.new
      @dealer_hand = Hand.new
      issue_cards
      place_bet
      Interface.show_cards(@user_hand, user)
      Interface.show_cards(@dealer_hand, dealer)

      loop do
        break if check_cards_length
        break if user_actions == 3
        dealer_actions
        Interface.show_cards(@user_hand, user)
        Interface.show_cards(@dealer_hand, dealer)
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
    user_hand.cards.length == 3 && dealer_hand.cards.length == 3
  end

  def user_actions
    show_tasks
    task_number = task
    @command_list[task_number][:command].call(user)
    task_number
  end

  def dealer_actions
    if validate_cards_count dealer_hand
      pass
    else
      add_card dealer
    end
  end

  def show_tasks
    Interface.action
    Interface.list @command_list
  end

  def issue_cards
    if validate_deck(@deck, 4)
      user_hand.add_cards(@deck.cards.slice!(0, 2))
      dealer_hand.add_cards(@deck.cards.slice!(0, 2))
      user_hand.calculate_count
      dealer_hand.calculate_count
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
    hand = player.type == :user ? user_hand : dealer_hand
    unless validate_cards_length(hand)
      if validate_deck(@deck, 1)
        card = @deck.cards.slice!(0, 1)
        hand.add_cards(card)
      else
        raise Interface.no_cards
      end
    end
    hand.calculate_count
  end

  def open_cards
    Interface.count user_hand, user
    Interface.count dealer_hand, dealer
    [user_hand.count, dealer_hand.count]
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
