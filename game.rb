require_relative "card"
require_relative "player"
require_relative "dealer"
require "pry"

class Game
  def initialize(num_players: 5)
    @num_players = num_players
    @dealer = Dealer.new(name: "the Dealer")
    @players = []
    @cards = []
    
    start_game
  end
  
  def start_game
    create_players
    create_cards
    shuffle
  end

  def create_players
    puts "You've selected a #{@num_players}-player game. Enter everyone's names here:"

    @num_players.times do |i|
      print "Player #{i+1}: "
      name = gets.chomp

      player = Player.new(position: i+1, name: name)
      @players << player
    end
  end

  def create_cards
    Card::VALUES.each do |v|
      Card::SUITS.each do |s|
        card = Card.new(suit: s, value: v)
        @cards << card
      end
    end
  end

  def shuffle
    2.times do |i|
      4.times do |j|
        print "Shuffling#{'.'*j}    \r"
        sleep 0.2
      end
    end
    puts
    @cards.shuffle!
    
    deal
  end

  def deal
    deck = @cards.map(&:clone)

    2.times do |i|
      @dealer.cards << deck.shift

      @players.each do |player|
        player.cards << deck.shift
      end
    end

    display_cards
  end

  def display_cards
    puts "Dealer: #{@dealer.hand}"
    sleep 0.75
    @players.each do |player|
      sleep 0.75
      puts "#{player.name}: #{player.hand}"
    end
    sleep 0.75

    determine_winner
  end

  def determine_winner
    scores = {}

    scores[@dealer] = @dealer.score

    @players.each do |player|
      scores[player] = player.score
    end

    scores = scores.sort_by { |k, v| -v }
    winner = scores.first[0]
    winning_score = scores.first[1]

    # Todo: Handle tie

    puts "The winner is #{winner.name} with #{winning_score} points!"
  end
end
