class WordBank
  attr_accessor :word_list
  def initialize
    self.word_list = []
    File.foreach("./lib/google-10000-english-no-swears.txt") do |line|
      item = line.chomp
      if item.size >= 5 && item.size <= 12
        self.word_list << item
      end
    end
  end

  def pick_word(solved_words)
    proxy_array = self.word_list - solved_words
    word = proxy_array.sample
    word
  end
end