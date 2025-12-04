class Player
  attr_accessor :name, :solved_words

  def initialize (name)
    @name = name
    self.solved_words = []
  end
end