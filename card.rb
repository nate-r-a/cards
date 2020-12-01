class Card
  # Aces high
  SUITS = %w[♠ ♥ ♦ ♣]
  VALUES = (2..14)

  attr_accessor :value

  def initialize(suit:, value:)
    @value = value
    @suit = suit
  end

  def to_s
    display_value = case @value
      when 11 then "J"
      when 12 then "Q"
      when 13 then "K"
      when 14 then "A"
      else @value
    end

    "#{display_value}#{@suit}"
  end
end