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
    
    # MAIN GAME LOOP START
    put "All right, lets hang around. You need to guess THE WORD! Or I'll hang you."
    engine.start_round(player)
    
    play = true
    until !play
      if engine.turns? != 0
        puts "You have #{engine.turns?} turns left. Name a letter or type '1' to save and exit."
        puts "=================="
        puts "Word looks like this right now:"
        puts engine.state?
        puts "=================="
        puts "Letter you have used:"
        puts engine.used?
        puts "=================="

        # Result reaction
        guess = validate_turn
        if guess == 1
          engine.process_result(nil)                           #SAVE CONDITION
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
      end
    end
    # MAIN GAME LOOP END
    
  end

  def play_sequence
    # Here should be a main gameloop.
  end

  def validate_turn
    valid = false
    until valid
      guess = gets.chomp
      if guess == 1
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