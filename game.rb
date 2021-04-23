# frozen_string_literal: true

require_relative './User'
require_relative './Dealer'
require_relative './Helper'
require_relative './Deck'
require_relative './bank'

class Game
  include Helper
  attr_reader :user, :dealer, :deck, :bank, :balance

  def initialize
    @command_list = {
        1 => { title: 'Пропустить', command: -> { pass } },
        2 => { title: 'Добавить карту', command: -> { |i| add_card i } },
        3 => { title: 'Открыть карты', command: -> { open_cards } },
    }
  end

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
    place_bet

    user_actions

    loop do
      break if check_cards_length
      user_actions
      dealer_actions
    end

  end

  def check_cards_length
    user.cards.length  == 3 && user.cards.length  == 3
  end

  def user_actions
    show_tasks
    task_number = task
    break if task_number == 1
    puts @command_list[task_number][:command].call(user)
  end

  def dealer_actions
    if validate_cards_count dealer
      break if pass
    else
      add_card dealer
    end
  end

  def show_tasks
    puts 'Введите действие : '
    @command_list.each do |k, v|
      puts "#{k} - #{v[:title]}"
    end
  end

  def task
    gets.chomp.to_i
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

  def pass
    true
  end

  def add_card(player)
    player.cards << @deck.slice!(0, 1) if validate_cards_length(player)
    player.calculate_count
  end

  def open_cards
    user_count = user.count
    dealer_count = dealer.count
    puts "Сумма очков у вам: #{user_count}"
    puts "Сумма очков у дилера: #{dealer_count}"
  end

  def calculate_result

  end

  def validate_cards_length(player)
    raise 'Должно быть 2 карты на руках' if player.cards.length != 2
  end

  def validate_cards_count(player)
    raise 'Должно быть 17 или более очков' if player.count > 17
  end

  def continue
    puts 'нажмите любую клавишу чтобы продолжить'
    gets
  end
end
