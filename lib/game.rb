require_relative 'engine'
require_relative 'player'
require_relative 'worldbank'
require_relative 'round'


class Game
  attr_accessor :player, :engine

  def initialize
    self.engine = Engine.new
  end

  def play
    puts 'This is Hangman game. Got name?'

    # A code for existing nickname pick here

    name = gets.chomp
    self.player = Player.new(name)
    puts "Hey, #{player.name}. First time?"
    
    # A code for game savefile pick here
    
    put "All right, lets hang around. You need to guess THE WORD! Or I'll hang you."
    engine.start_round(player)
    

    
  end

end