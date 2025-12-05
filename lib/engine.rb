require_relative 'round'
require_relative 'wordbank'
require_relative 'player'

class Engine

  attr_accessor :word, :round, :bank, :player
  def initialize
    self.bank = WordBank.new
  end

  def start_round(player)
    self.word = bank.pick_word(player.solved_words)
    self.round = Round.new(word)
    self.player = player
  end

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

  def turns?
    round.turns_left
  end

  def win?
    check = round.current_state.include?("_ ")
    check
  end

  def process_result(result)
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
    end
    self.round = nil
  end

  def state?
    state = round.current_state.join.strip
    state
  end

  def used?
    used = []
    round.used_letters.each {|i| used << "#{i} "}
    used.join.strip
  end
end