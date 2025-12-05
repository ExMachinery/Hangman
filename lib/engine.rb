require_relative 'round'
require_relative 'wordbank'
require_relative 'player'

class Engine

  attr_accessor :word, :round, :bank
  def initialize
    self.bank = WordBank.new

  end

  def start_round(player)
    self.word = bank.pick_word(player.solved_words)
    self.round = Round.new(word)
  end

  def process_turn(letter)
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
end