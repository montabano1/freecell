require_relative 'card'

class Deck
  attr_reader :cards
  # Returns an array of all 52 playing cards.
  def self.all_cards
    ans = []
    Card.values.each do |val|
      Card.suits.each do |suit|
        ans << Card.new(suit, val)
      end
    end
    ans.shuffle!
  end

  def initialize(cards = Deck.all_cards)
    @cards = cards
  end

  def count
    @cards.length
  end
end
