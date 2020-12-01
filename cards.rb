#ruby
#!/usr/bin/env ruby
require 'optparse'
require_relative "game"

options = {}

OptionParser.new do |parser|
  parser.on("-n", "--numplayers NUM_PLAYERS", "The number of players") do |num|
    options[:num_players] = num
  end
end.parse!

num = options[:num_players].to_i
if num < 2 || num > 25
  $stderr.puts "Please enter a value for -n between 2 and 25."
else
  Game.new(num_players: num)
end