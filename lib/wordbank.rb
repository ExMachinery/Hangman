# Занимается выдачей слов.

class WordBank
  attr_accessor :word_list, :word
  def initialize
    self.word_list = []
    file = File.open("google-10000-english-no-swears.txt")
    while line = file.gets do
      if line.size >= 5 && line.size <= 12
        self.word_list << line
      end
    end
    file.close
  end

  def pick_word(solved_words)
    self.word = nil
    unless solved_words.include?(word)
      self.word = word_list.sample
    end
    word
  end
end