# frozen_string_literal: true

require_relative './helper'

class Interface
  class << self
    include Helper

    def list(item)
      item.each { |k, v| puts "#{k} - #{v[:title]}" }
    end

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

    def count(hand, player)
      puts "Сумма очков у #{player.name}: #{hand.calculate_count}"
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

    def show_cards(hand, player)
      puts "Карты у #{player.name}: "
      if player.type == :dealer
        hand.cards.each { print '* ' }
      else
        hand.cards.each { |i| print "#{i.suit}-#{i.value} " }
      end
      print "\n"
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
