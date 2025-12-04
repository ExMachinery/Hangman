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
end