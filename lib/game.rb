require_relative 'engine'
require_relative 'player'
require_relative 'wordbank'
require_relative 'round'

# 1. Communicate with player
# 2. Input validation
# ===========
# NEXT STEP: Picking existing nickname logic.
# ===========
# To do:
# 1. Picking existing nickname
# 2. Loading save file

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
    
    # New game
    play = true
    until play == false
      play_sequence
      valid = false
      until valid
        puts "One more? Type 'Y' for another round, 'n' for exit."
        one_more = gets.chomp
        if one_more == "Y"
          valid = true
          break
        elsif one_more == "n"
          puts "Fine. See you."
          valid = true
          play = false
        else 
          puts "You had one job, #{player.name}... You can't just #{one_more}-ing your way out."
        end
      end
    end
  end

  def play_sequence
    puts "All right, lets hang around. You need to guess THE WORD! Or I'll hang you."
    
    play = true
    engine.start_round(player)
    until !play
      if engine.turns? != 0
        puts "You have #{engine.turns?} turns left. Name a letter or type '1' to save and exit."
        puts "=================="
        puts "Word looks like this right now:"
        puts engine.state?
        puts "=================="
        puts "Letters you have used:"
        puts engine.used?
        puts "=================="

        # Result reaction
        guess = validate_turn
        if guess == "1"
          engine.process_result(nil)                           #SAVE CONDITION
          play = false
        else
          result = engine.process_turn(guess)
          if result
            puts "You're god damn right!"
            if engine.win?
              play = false
              puts "You can live. For now."
              engine.process_result(true)                      #WINNING CONDITION
            end
          else
            puts "You shot. You missed."
          end
        end
      else 
        puts "You lost. You hanged. Not sorry."
        engine.process_result(false)                           #LOOSING CONDITION
        play = false
      end
    end
  end

  # Turn validation. Sort out used letters and catch an Save Command ("1")
  def validate_turn
    valid = false
    until valid
      guess = gets.chomp
      if guess == "1"
        valid = true
      elsif guess.match?(/^[a-zA-Z]$/)
        guess = guess.downcase
        if engine.round.used_letters.include?(guess)
          puts "Letter used. Take one more shot."
        else
          valid = true
        end
      else
        puts 'Come again?' 
      end
    end
    guess
  end

end