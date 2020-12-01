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

  private
  
  def start_game
    create_players
    create_cards
    shuffle_cards
  end

  def create_players
    puts "You've selected a #{@num_players}-player game. Enter everyone's names here:"

    @num_players.times do |i|
      print "Player #{i+1}: "
      name = gets.chomp

      while name.empty?
        $stderr.puts "A player's name cannot be blank."
        print "Player #{i+1}: "
        name = gets.chomp
      end

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

  def shuffle_cards
    2.times do |i|
      4.times do |j|
        print "Shuffling and dealing#{'.'*j}    \r"
        sleep 0.2
      end
    end
    sputs
    @cards.shuffle!
    
    deal
  end

  def deal
    # Todo: Consider not cloning cards and just moving cards in and out from @cards
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
    sputs "Dealer: #{@dealer.hand}"
    @players.each do |player|
      sputs "#{player.name}: #{player.hand}"
    end

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
    sputs "The winner is #{winner.name} with #{winning_score} points!"

    # Not pretty
    $stderr.puts "There was a tie in this round." if scores[0][1] == scores[1][1]

    play_again?
  end

  def play_again?
    print "Play another round? (y/n): "
    response = gets.chomp

    if ["y", "yes"].include? response.downcase
      reset_hands
      shuffle_cards
    else
      puts "Thanks for playing!"
      exit(true)
    end
  end

  def reset_hands
    @dealer.cards = []
    @players.each{ |p| p.cards = [] }
  end

  def sputs(text=nil, sleep_time=1)
    sleep sleep_time
    puts text
  end
end
