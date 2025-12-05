# Хранит слово, состояние слова, количество попыток, названные буквы.
 
class Round
  attr_accessor :word, :turns_left, :used_letters, :current_state, :win

  def initialize(word)
    self.turns_left = 12
    self.used_letters = []
    self.word = word
    self.current_state = []
    word.split("").each do |i|
      self.current_state << "_ "
    end
  end

  def change_state(array, letter)
    array.each do |i|
      self.current_state[i] = "#{letter.upcase} "
    end
    self.used_letters << letter
  end
end