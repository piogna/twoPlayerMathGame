class Player
  attr_reader :lives
  attr_reader :score
  attr_reader :name
  def initialize()
    @lives = 3
    @score = 0
  end

  def lose_life
    @lives -= 1
  end

  def add_to_score
    @score += 1
  end

  def reset
    @lives = 3
    @score = 0
  end
end
