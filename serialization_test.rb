require 'yaml'

class Weapon
  attr_accessor :name, :damage
  def initialize(name, damage)
    @name = name
    @damage = damage
  end
end

class GameState
  attr_accessor :player_name, :score, :weapon

  def initialize(name, score, weapon)
    @player_name = name
    @score = score
    @weapon = weapon
  end
end

sword = Weapon.new("Excalibur", 50)
state = GameState.new("Alice", 100, sword)

yaml_string = YAML.dump(state)
puts "Serialized:"
puts yaml_string

File.write("test_save.yml", yaml_string)

loaded_yaml = File.read("test_save.yml")
loaded_state = YAML.load(loaded_yaml, permitted_classes: [GameState, Weapon])

puts "/nDeserialized:"
puts "Name: #{loaded_state.player_name}"
puts "Score: #{loaded_state.score}"
puts "Weapon: #{loaded_state.weapon.damage}"