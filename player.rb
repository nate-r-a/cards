class Player
  attr_accessor :name, :cards

  def initialize(position:, name:)
    @position = position
    @name = name
    @cards = []
  end

  def hand
    @cards.map(&:to_s).join(", ")
  end

  def score
    @cards.sum(&:value)
  end
end