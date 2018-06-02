require_relative 'card.rb'
require_relative 'deck.rb'
require 'byebug'

class Board

#an array in order of strength/value least to greatest
  CARD_STRENGTH = [
    :ace,
    :deuce,
    :three,
    :four,
    :five,
    :six,
    :seven,
    :eight,
    :nine,
    :ten,
    :jack,
    :queen,
    :king
  ]

  attr_reader :piles, :freecells, :foundations

  def initialize(deck)
    @piles = Array.new(8) { Array.new }
    @freecells = Array.new(4) { Array.new }
    @foundations = Array.new(4) { Array.new }
    @deck = deck
    populate
  end

  def populate
    52.times do
      @piles.first << @deck.cards.shift
      @piles.rotate!
    end
  end

  def one_value_bigger?(smaller, bigger)
    CARD_STRENGTH.index(bigger.value) == CARD_STRENGTH.index(smaller.value) + 1
  end

  def different_color?(card1, card2)
    if [:clubs, :spades].include?(card1.suit)
      return false if [:clubs, :spades].include?(card2.suit)
    else
      return false if [:hearts, :diamonds].include?(receiver.suit)
    end
  end

  def valid_board_move?(pile_moved, receiver)
    return false unless different_color?(pile_moved.first, receiver)
    return false unless one_value_bigger?(pile_moved.first, receiver)
    true
  end

  def valid_freecell_move?(freecell_index)
    @freecells[freecell_index].empty?
  end

  def valid_foundations_move?(card, foundations_index)
    return true if @foundations[foundations_index].empty? && card.value == :ace
    return false if @foundations[foundations_index].empty?
    return false unless one_value_bigger?(@foundations[foundations_index], card)
    return false unless @foundations[foundations_index].suit == card.suit
    true
  end

  def choose_multiple_cards(amt_from_top, pile) #first card is 0 from top
    i = pile.length - amt_from_top - 1
    while i < pile.length - 1
      unless different_color?(pile[i], pile[i+1])
        puts "that is not a valid choice"
        break
      end
      i += 1
    end
    pile[pile.length - amt_from_top - 1..-1]
  end

  def move_piles(from_pile_idx, amt_from_top, to_pile_idx)
    @piles[to_pile_idx] += choose_multiple_cards(amt_from_top, @piles[from_pile_idx])
    (amt_from_top+ 1).times do @piles[from_pile_idx].pop
    end
  end

  def move_to_freecell(pile, freecell_index)
    if valid_freecell_move?(freecell_index)
      @freecells[freecell_index] = pile.last
      pile.pop
    else
      puts "that space is not free"
    end
  end

  def move_to_foundations(pile, foundations_index)
    if @foundations[foundations_index] == []
      if pile.last.value == :ace
        @foundations[foundations_index] = pile.pop
        return nil
      end
    end

    if valid_foundations_move?(pile.last, foundations_index)
      @foundations[foundations_index] += pile.last
      pile.pop
    else
      puts "invalid foundations move"
    end
  end

  def move_from_freecell(freecell_index, pile_idx)
    @pile[pile_idx] << @freecells[freecell_index].pop
  end

end
