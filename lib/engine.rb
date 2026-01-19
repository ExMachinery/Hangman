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

  # Method loads saved round by player name
  def load_round(player)
    save_file = File.read("./accounts/#{player.name}/save.yml")
    self.round = YAML.load(save_file, permitted_classes: [Round])
    self.word = round.word
  end

  # ACCEPT: Player letter from Game.
  # RETURN: 
  #   FALSE: If its wrong letter
  #   TRUE: If its right
  # Also substract turns.
  def process_turn(letter)
    round.turns_left -= 1
    work_array = word.split("").each_with_index.select { |val, ind| val == letter }.map { |val, ind| ind}
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
    !round.current_state.include?("_")
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
      yaml_round = YAML.dump(round)
      File.write("./accounts/#{player.name}/save.yml", yaml_round)
    end
    yaml_player = YAML.dump(player)
    File.write("./accounts/#{player.name}/#{player.name}.yml", yaml_player)
    self.round = nil
  end

  # RETURN: this round current word state
  def state?
    state = round.current_state.join("|")
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