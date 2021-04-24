# frozen_string_literal: true

require_relative './helper'

class Interface
  class << self
    include Helper

    def name
      print 'Ведите ваше имя: '
    end

    def repeat
      puts 'Хотите сыграть еще раз: (да/нет)'
      play_again = string
      play_again != 'да'
    end

    def replay
      puts 'Начать игру заново?: (да/нет)'
      replay = string
      replay == 'да'
    end

    def action
      puts 'Введите действие : '
    end

    def no_cards
      'В колоде недостаточно карт'
    end

    def no_user_money
      'У Вас закочились деньги'
    end

    def no_dealer_money
      'У дилера закончились деньги'
    end

    def count(player)
      puts "Сумма очков у #{player[:player].name}: #{player[:count]}"
    end

    def win
      puts 'Вы выграли'
    end

    def draw
      puts 'Ничья'
    end

    def defeat
      puts 'Вы проиграли'
    end

    def cards(player, type)
      puts "Карты у #{player[:player].name}: "
      if type == 'hide'
        player[:cards].each { print '* ' }
      else
        player[:cards].each { |i| print "#{i.suit}-#{i.value} " }
      end
      print "\n"
    end

    def show_cards(hand)
      cards hand.user, 'open'
      cards hand.dealer, 'hide'
    end

    def error(e)
      puts e.message.to_s
    end

    def task(number)
      task = {
        1 => 'Пропустить',
        2 => 'Добавить карту',
        3 => 'Открыть карты'
      }
      task[number]
    end
  end
end
