require_relative 'card.rb'
require_relative 'board.rb'
require_relative 'deck.rb'

class Game

  attr_reader :board

  def initialize(board)
    @board = board
  end

  def play
    render
    until won?
      puts "Choose a starting pile (0-7) or 'F' = freecells"
      starting_idx = gets.chomp

      if starting_idx == 'F' || starting_idx == 'f'
        location = 'Y'
      else
        starting_pile = board.piles[starting_idx.to_i]
        puts "Choose a location ('X' = Foundations, 'F' = Freecell, 'B' = Board)"
        location = gets.chomp
      end

      if location.upcase == 'F'
        puts "Choose a Freecell index (0-3)"
        freecell_index = gets.chomp.to_i
        board.move_to_freecell(starting_pile, freecell_index)
      elsif location.upcase == 'X'
        (0..3).to_a.each do |num|
          if board.valid_foundations_move?(starting_pile.last, num)
            board.move_to_foundations(starting_pile, num)
          end
        end
      elsif location.upcase == 'B'
        puts "Choose a receiving pile (0-7)"
        receiving_pile = gets.chomp.to_i
        board.move_piles(board.piles.index(starting_pile), receiving_pile)
      elsif location.upcase == 'Y'
        puts "pick a Freecell index (0-3)"
        freecell_index = gets.chomp.to_i
        puts "pick a pile (0-7)"
        # board.move_from_freecell(freecell_index, pile_idx)
      end
      render
      sleep(2)
    end
  end

  def render
    system('clear')
    puts ''
    puts '           FREECELLS                                   FOUNDATIONS'
    puts '     0      1      2      3                      0      1      2      3'
    puts "    | #{board.freecells[0][0].to_s} |   | #{board.freecells[1][0].to_s} |   | #{board.freecells[2][0].to_s} |   | #{board.freecells[3][0].to_s} |                   |#{board.foundations[0][0].to_s}|   |#{board.foundations[1][0].to_s}|   |#{board.foundations[2][0].to_s}|   |#{board.foundations[3][0].to_s}|"
    puts ""
    puts ""
    puts '          BOARD '
    board.piles.each_with_index do |pile, idx|
      print "#{idx}-"
      pile.each do |card|
        print " |#{card.to_s}| "
      end
      puts ''
    end
    puts ''
  end

  def won?
    board.foundations.all? {|fc| fc.is_a?(Card) && fc.value == :king}
  end
end

d = Deck.new
b = Board.new(d)
g = Game.new(b)
g.play
