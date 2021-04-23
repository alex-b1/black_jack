# frozen_string_literal: true

module Helper
  def string
    gets.chomp.to_s.strip
  end

  def task
    gets.chomp.to_i
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
