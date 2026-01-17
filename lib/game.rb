require 'yaml'
require 'fileutils'
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
  attr_accessor :player, :engine, :accounts

  def initialize
    self.engine = Engine.new
  end

  def play
    puts 'This is Hangman game. First time?'
    valid = false
    until valid
      puts 'Check if you on the list and tell me your number. Or just type "First time" to create new account.'
      self.accounts = account_list
      
      input = gets.chomp
      if input.downcase == "first time"
        create_new_player
        valid = true
      elsif input.match?(/^[d+]$/)
        if accounts[input.to_i] != nil
          loading_sequence(input)
          valid = true
        else
          puts "You'd better remember how to count and try again."
        end
      end
    end
    
    # New game
    play = true
    while play
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

  # Validate and create a new Player. 
  def create_new_player
    puts "Ah... A new guy. What is your name?"
    nickname_is_free = false
    until nickname_is_free
      name = gets.chomp
      if accounts.include?(name)
        puts "This guy was hanged. You ain't. Try again with another name."
      elsif name == ""
        puts "Mr. Nobody? You have a body, and we're going to hang it, funny man. Just name the body."
      else
        nickname_is_free = true
        self.player = Player.new(name)
        FileUtils.makedirs("./accounts/#{player.name}")
        yaml_player = YAML.dump(player)
        File.write("../accounts/#{player.name}/#{player.name}.yml", yaml_player)
      end
    end
  end

  # [WIP] Should load a Player object into the Game
  def loading_sequence(input)
    player_name = accounts[input.to_i]
    self.player = File.read("../accounts/#{player_name}/#{player_name}.yml")
    if File.exist?("../accounts/#{player_name}}/save.yml")
      puts "You have unfinished business. Type '1' for load saved game, or '2' if you want a fresh start."
      
      valid = false
      until valid
        choice = gets.chomp
        if choice == "1"
          valid = true
          engine.load_round(player)
        elsif choice == "2"
          valid = true
          File.delete("../accounts/#{player.name}/save.yml")
        else
          puts "Can't count to two? Maybe i should hang you and end your suffering right now..."
        end
      end
    end
  end 

  def play_sequence
    puts "All right, lets hang around. You need to guess THE WORD! Or I'll hang you."    
    play = true

    if !engine.round
      engine.start_round(player)
    end

    while play
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
          engine.process_result(nil, player)                           #SAVE CONDITION
          play = false
        else
          result = engine.process_turn(guess)
          if result
            puts "You're god damn right!"
            if engine.win?
              play = false
              puts "You can live. For now."
              engine.process_result(true, player)                      #WINNING CONDITION
            end
          else
            puts "You shot. You missed."
          end
        end
      else 
        puts "You lost. You hanged. Not sorry."
        engine.process_result(false, player)                           #LOOSING CONDITION
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
        if engine.letter_used?(guess)
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

  # Accounts array and printing
  def account_list
    accounts = Dir.children("/accounts")
    i = 1
    accounts.each do |acc|
      puts "#{i}. #{acc}"
      i += 1
    end
    accounts
  end
end