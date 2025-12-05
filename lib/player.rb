class Player
  attr_accessor :name, :solved_words, :wins, :hanged

  def initialize (name)
    @name = name
    self.solved_words = []
    self.wins = 0
    self.hanged = 0
  end
end