# frozen_string_literal: true

require_relative './user'
require_relative './dealer'
require_relative './helper'
require_relative './deck'
require_relative './bank'

class Game
  MAX_COUNT = 21

  include Helper
  attr_reader :user, :dealer, :deck, :bank, :balance

  def initialize
    @command_list = {
      1 => { title: 'Пропустить', command: lambda { |i| pass } },
      2 => { title: 'Добавить карту', command: lambda { |i| add_card i } },
      3 => { title: 'Открыть карты', command: lambda { |i| open_cards } },
    }
  end

  def init
    print 'Ведите ваше имя: '
    name = string
    @user = User.new(name)
    @dealer = Dealer.new
    @deck = Deck.new
    @deck.cards.shuffle!
    @bank = Bank.new
    @balance = bank.balance
    start
  end

  def start
    loop do
      issue_cards
      place_bet
      show_cards

      loop do
        break if check_cards_length
        break if user_actions
        dealer_actions
        show_cards
      rescue StandardError => e
        puts "Ошибка: #{e.message}"
        continue
      end

      calculate_result
      puts "Хотите сыграть еще раз: (да/нет)"
      play_again = string
      break if play_again != 'да'
      clear
    end
  end

  def show_cards
    print "Ваши карты: "
    user.cards.each { |i| print "#{i.suit}-#{i.value} "}
    print "\nКарты дилера: "
    dealer.cards.each { |i| print "* " }
    print "\n"
  end

  def check_cards_length
    user.cards.length == 3 && user.cards.length == 3
  end

  def user_actions
    show_tasks
    task_number = task
    @command_list[task_number][:command].call(user)
    if task_number == 3
      true
    end
  end

  def dealer_actions
    if validate_cards_count dealer
      pass
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
    user.cards = @deck.cards.slice!(0, 2)
    user.calculate_count
    dealer.cards = @deck.cards.slice!(0, 2)
    dealer.calculate_count
  end

  def place_bet
    user.bank.withdraw(10)
    dealer.bank.withdraw(10)

    bank.put_in(20)
  end

  def pass
    true
  end

  def add_card(player)
    player.cards.concat(@deck.cards.slice!(0, 1)) if validate_cards_length(player)
    player.calculate_count
  end

  def open_cards
    user_count = user.count
    dealer_count = dealer.count
    puts "Сумма очков у вам: #{user_count}"
    puts "Сумма очков у дилера: #{dealer_count}"
  end

  def calculate_result
    user_count = user.count
    dealer_count = dealer.count
    if user_count > MAX_COUNT
      puts 'Вы проиграли'
      dealer.bank.put_in(20)
    elsif user_count == dealer_count
      puts 'Ничья'
      user.bank.put_in(10)
      dealer.bank.put_in(10)
    elsif user_count > dealer_count
      puts 'Вы выграли'
      user.bank.put_in(10)
    else
      puts 'Выграл дилер'
      dealer.bank.put_in(20)
    end
  end

  def validate_cards_length(player)
    raise 'Должно быть 2 карты на руках' if player.cards.length > 2
    true
  end

  def validate_cards_count(player)
    raise 'Должно быть 17 или более очков' if player.count > 17
    true
  end

  def continue
    puts 'нажмите любую клавишу чтобы продолжить'
    gets
  end

  def clear
    if Gem.win_platform?
      system 'cls'
    else
      system 'clear'
    end
  end
end

game = Game.new
game.init
