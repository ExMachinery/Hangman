require_relative 'round'
require_relative 'wordbank'
require_relative 'player'

# 1. Create WordBank
# 2. Accept new word
# 3. Create new round for word
# 4. Processing letter
#   FALSE: If miss the letter
#   TRUE: If letter is in word.
#=============================
# To do:
# 1.1 Rewrite methods which use `player` with player acceptance as a parameter
# 1.2 Rewrite `.process_trun` as a sequence of select and map methods.
# 1. For `.process_result`: save file creation.
#   - Serialize round
#   - Save it to players dir
# 2. Method for load saved round
 

class Engine
  attr_accessor :word, :round, :bank
  def initialize
    self.bank = WordBank.new
  end

  def start_round(player)
    self.word = bank.pick_word(player.solved_words)
    self.round = Round.new(word)
  end

  # ACCEPT: Player letter from Game.
  # RETURN: 
  #   FALSE: If its wrong letter
  #   TRUE: If its right
  # Also substract turns.
  def process_turn(letter)
    round.turns_left -= 1
    work_array = []
    word.split("").each_with_index do |val, ind|
      if val == letter
        work_array << ind
      end
    end
    if work_array.empty?
      round.used_letters << letter
      false
    else
      round.change_state(work_array, letter)
      true
    end
  end

  # RETURN: How many turns left
  def turns?
    round.turns_left
  end

  # RETURN:
  #   FALSE: Word not guessed yet.
  #   TRUE: Word guessed.
  def win?
    check = !round.current_state.include?("_ ")
    check
  end

  # Close round results. Saves player's score.
  def process_result(result, player)
    if result 
      round.win = result
      player.solved_words << word
      player.wins += 1
    elsif result == false
      round.win = result
      player.hanged += 1
    elsif result == nil
      # Save condition
      # Serialize round
      yaml_round = YAML.dump(round)
      File.write("../accounts/#{player.name}/save.yaml", yaml_round)
    end
    yaml_player = YAML.dump(player)
    File.write("../accounts/#{player.name}/#{player.name}.yml", yaml_player)
    self.round = nil
  end

  # RETURN: this round current word state
  def state?
    state = round.current_state.join.strip
    state
  end

  # RETURN: this round used letters 
  def used?
    used = []
    round.used_letters.each {|i| used << "#{i} "}
    used.join.strip
  end

  # engine.round.used_letters.include?(guess)
  def letter_used?(guess)
    result = round.used_letters.include?(guess)
    result
  end
end