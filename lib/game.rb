require_relative 'engine'
require_relative 'player'
require_relative 'worldbank'
require_relative 'round'


class Game
  attr_accessor :player, :engine

  def initialize
    self.engine = Engine.new
  end

  def play
    puts 'This is Hangman game. Got name?'

    # A code for existing nickname pick here

    name = gets.chomp
    self.player = Player.new(name)
    puts "Hey, #{player.name}. First time?"
    
    # A code for game savefile pick here
    
    put "All right, lets hang around. You need to guess THE WORD! Or I'll hang you."
    engine.start_round(player)

    if engine.round.turns_left != 0
      engine.round.turns_left -= 1
      puts "You have #{engine.round.turns_left} turns left. Name a letter or type '1' to save and exit."
      puts "=================="
      puts "Word looks like this right now:"
      engine.round.print_state
      puts "=================="
      puts "Letter you have used:"
      engine.round.print_used
      puts "=================="
      
      # Guess validation (It should be a method)
      valid = false
      result = nil
      until valid
        guess = gets.chomp
        if guess == 1
          valid = true
          # Saving game code here. Saving condition.
        elsif guess.match?(/^[a-zA-Z]$/)
          guess = guess.downcase
          if engine.round.used_letters.include?(guess)
            puts "Letter used. Take one more shot."
          else
            valid = true
            result = engine.process_turn(guess)
          end
        else
          puts 'Come again?' 
        end
      end

      # Result reaction
      if result
        puts "You're god damn right!"
        if !engine.round.current_state.include?("_ ")
          # Winning condition
        end
      else
        puts "You shot. You miss."
      end
    else 
      puts "You lost. You hanged. Not sorry."
      # Loosing condition
    end
  end

end