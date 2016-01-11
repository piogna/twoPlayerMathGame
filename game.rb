require "./player"
require "./exceptions"
class Game
  attr_accessor :player_one
  attr_accessor :player_two
  attr_accessor :turn
  REGEX = /(\d{1,2})\s(plus|minus|multiplied by)\s(\d{1,2})/
  OPERATIONS = ["plus", "minus", "multiplied by"]

  def initialize
    @turn = 1
  end

  def play
    on_start
    game_loop
  end

  def on_start
    puts "Welcome to the Math Game!"
    begin
      print "Player 1! What is your name? "
      name = gets.chomp
      raise InvalidNameError if name.length < 1
    rescue InvalidNameError
      puts "You have to put in a name"
      retry
    end
    @player_one = Player.new(name)
    puts "Welcome, #{name}!"
    begin
      print "Player 2! What is your name? "
      name = gets.chomp
      raise InvalidNameError if name.length < 1
    rescue InvalidNameError
      puts "You have to put in a name"
      retry
    end
    @player_two = Player.new(name)
    puts "Welcome, #{name}!"
  end

  def get_problem
    num_one = Random.rand(1..20)
    num_two = Random.rand(1..20)
    operator_selector = Random.rand(0..2)
    return "What is #{num_one} #{OPERATIONS[operator_selector]} #{num_two}?"
  end

  def answer_correct?(problem, answer)
    parsed_problem = problem.match(REGEX)
    first_number = parsed_problem[1]
    second_number = parsed_problem[3]
    operator = get_operator_from_text parsed_problem[2]
    eval_problem = "#{first_number} #{operator} #{second_number}"
    answer.to_i == eval(eval_problem)
  end

  def get_operator_from_text(string)
    operator ||= ""
    case string
    when "plus"
      operator = " + "
    when "minus"
      operator = " - "
    when "multiplied by"
      operator = " * "
    end
  end

  def game_loop
    keep_playing = true
    while keep_playing
      unless @turn % 2 == 0
        @player_one = next_turn @player_one
        display_update
        unless @player_one.has_lives?
          puts "Oh no! #{@player_one.name} has no more lives."
          puts "Final score is:"
          puts "#{@player_one.name}: #{@player_one.score}"
          puts "#{@player_two.name}: #{@player_two.score}"

          print "Play again (y/n)? "
          if gets.chomp == "n"
            keep_playing = false
          end
        end
      else
        @player_two = next_turn @player_two
        display_update
        unless @player_one.has_lives?
          puts "Oh no! #{@player_two.name} has no more lives."
          puts "Final score is:"
          puts "#{@player_one.name}: #{@player_one.score}"
          puts "#{@player_two.name}: #{@player_two.score}"

          print "Play again (y/n)? "
          if gets.chomp == "n"
            keep_playing = false
          end
        end
      end
    end
  end

  def next_turn(player)
    puts "Turn number #{@turn}"
    problem = get_problem
    begin
      puts "#{player.name}! Here is your question! \n#{problem}"
      answer = gets.chomp
      raise InvalidGuessError unless (answer.length > 0 && answer =~ /\\d+/)
    rescue InvalidGuessError
      puts "You have to input a valid number."
      retry
    end
    if answer_correct? problem, answer
      player.add_to_score
      puts "Great job, #{@player_one.name}! You got it right!"
      puts "Your score is #{player.score}."
    else
      player.lose_life
      puts "Oh no, #{player.name}! You got that one wrong!"
    end
    @turn += 1
    player
  end

  def display_update
    puts "Current score is:"
    puts "#{@player_one.name}: #{@player_one.score}"
    puts "#{@player_two.name}: #{@player_two.score}"

    puts "Current lives are:"
    puts "#{@player_one.name}: #{@player_one.lives}"
    puts "#{@player_two.name}: #{@player_two.lives}"
  end
end
