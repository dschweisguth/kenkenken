require_relative '../lib/game'
require_relative '../lib/box/difference'
require_relative '../lib/box/dividend'
require_relative '../lib/box/product'
require_relative '../lib/box/solution'
require_relative '../lib/box/sum'

RSpec.describe Game do
  describe '.new' do
    it "raises if a cell is in more than one box" do
      boxes = [
        Box::Solution.new(1, 1, [[0, 0]]),
        Box::Solution.new(1, 1, [[0, 0]])
      ]
      expect { Game.new boxes }.to raise_error "Cell 0, 0 is in more than one box"
    end

    it "raises if the given boxes don't form a square" do
      boxes = [Box::Sum.new(2, 3, [[0, 0], [1, 0]])]
      expect { Game.new boxes }.to raise_error "Grid is 1 cells high but row 0 is 2 cells wide"
    end

    it "raises if a box's grid size differs from the grid" do
      boxes = [Box::Sum.new(3, 6, [[0, 0], [1, 0], [0, 1], [1, 1]])]
      expect { Game.new boxes }.to raise_error "Grid size is 2, but a cell has 3 possibilities"
    end
  end

  describe '#solution' do
    it "solves the simplest game" do
      boxes = [Box::Solution.new(1, 1, [[0, 0]])]
      expect_solution boxes, [[1]]
    end

    it "eliminates duplicates in rows and columns within a box" do
      boxes = [
        Box::Solution.new(2, 1, [[0, 0]]),
        Box::Sum.new(2, 5, [[1, 0], [0, 1], [1, 1]])
      ]
      expect_solution boxes, [[1, 2], [2, 1]]
    end

    it "eliminates duplicates in entire rows and columns" do
      # Without row & column elimination or guessing, this game could not be solved.
      # Without row & column elimination, we'd guess 1 at [0, 0] and have to work through
      # many subsidiary guesses before guessing 3 at [0, 0].
      # With row & column elimination, we solve the game in two rounds of elimination,
      # without guessing.
      # This game also requires repeated elimination. Boxes don't affect other boxes,
      # so one iteration through boxes is always enough; only a game that requires row &
      # column elimination can also require repeated elimination.
      boxes = [
        Box::Sum.new(3, 5, [[0, 0], [1, 0], [0, 1]]),
        Box::Solution.new(3, 2, [[2, 0]]),
        Box::Sum.new(3, 11, [[1, 1], [2, 1], [0, 2], [1, 2], [2, 2]])
      ]
      expect_solution boxes, [[3, 1, 2], [1, 2, 3], [2, 3, 1]]
    end

    # The algorithm needed to solve the previous game suffices to solve this game.
    # Guessing is still not needed. Wonder if this is true for all Times 5x5 puzzles?
    it "solves the small puzzle" do
      boxes = [
        Box::Sum.new(5, 7, [[0, 0], [0, 1], [1, 1]]),
        Box::Dividend.new(5, 2, [[1, 0], [2, 0]]),
        Box::Difference.new(5, 2, [[3, 0], [4, 0]]),
        Box::Solution.new(5, 3, [[2, 1]]),
        Box::Product.new(5, 80, [[3, 1], [4, 1], [3, 2]]),
        Box::Difference.new(5, 2, [[0, 2], [0, 3]]),
        Box::Difference.new(5, 2, [[1, 2], [2, 2]]),
        Box::Solution.new(5, 2, [[4, 2]]),
        Box::Sum.new(5, 9, [[1, 3], [2, 3]]),
        Box::Solution.new(5, 2, [[3, 3]]),
        Box::Difference.new(5, 2, [[4, 3], [4, 4]]),
        Box::Difference.new(5, 1, [[0, 4], [1, 4]]),
        Box::Dividend.new(5, 2, [[2, 4], [3, 4]])
      ]
      expected_solution = [
        [5, 4, 2, 1, 3],
        [3, 5, 4, 2, 1],
        [1, 3, 5, 4, 2],
        [2, 1, 3, 5, 4],
        [4, 2, 1, 3, 5]
      ].reverse
      expect_solution boxes, expected_solution
    end

    # +7 +7 +3   3 1 2
    # +3 +7 +3 → 2 3 1
    # +3 +5 +5   1 2 3
    it "eliminates partitions in rows and columns, 3z3" do
      boxes = [
        Box::Sum.new(3, 3, [[0, 0], [0, 1]]),
        Box::Sum.new(3, 5, [[1, 0], [2, 0]]),
        Box::Sum.new(3, 7, [[1, 1], [0, 2], [1, 2]]),
        Box::Sum.new(3, 3, [[2, 1], [2, 2]])
      ]
      expected_solution = [[1, 2, 3], [2, 3, 1], [3, 1, 2]]
      expect_solution boxes, expected_solution
    end

    # The algorithm needed to solve the previous game suffices to solve this game
    #  +6 +11  +8  +8  +8   5 4 1 3 2
    #  +6 +11 +11  +8 +12   1 3 4 2 5
    #  x8 x10 x10  x5 +12 → 4 5 2 1 3
    #  x8  x3  x3  x5 +12   2 1 3 5 4
    #  +5  +5 x20 x20 x20   3 2 5 4 1
    it "eliminates partitions in rows and columns, 5x5" do
      boxes = [
        Box::Sum.new(5, 5, [[0, 0], [1, 0]]),
        Box::Product.new(5, 20, [[2, 0], [3, 0], [4, 0]]),
        Box::Product.new(5, 8, [[0, 1], [0, 2]]),
        Box::Product.new(5, 3, [[1, 1], [2, 1]]),
        Box::Product.new(5, 5, [[3, 1], [3, 2]]),
        Box::Sum.new(5, 12, [[4, 1], [4, 2], [4, 3]]),
        Box::Product.new(5, 10, [[1, 2], [2, 2]]),
        Box::Sum.new(5, 6, [[0, 3], [0, 4]]),
        Box::Sum.new(5, 11, [[1, 3], [2, 3], [1, 4]]),
        Box::Sum.new(5, 8, [[3, 3], [2, 4], [3, 4], [4, 4]])
      ]
      expected_solution = [
        [5, 4, 1, 3, 2],
        [1, 3, 4, 2, 5],
        [4, 5, 2, 1, 3],
        [2, 1, 3, 5, 4],
        [3, 2, 5, 4, 1]
      ].reverse
      expect_solution boxes, expected_solution
    end

    # Solving this game quickly requires guessing box combos rather than cells
    it "solves the large puzzle" do
      boxes = [
        Box::Sum.new(7, 14, [[0, 0], [1, 0], [2, 0], [3, 0]]),
        Box::Solution.new(7, 7, [[4, 0]]),
        Box::Product.new(7, 12, [[5, 0], [6, 0]]),
        Box::Sum.new(7, 11, [[0, 1], [1, 1], [2, 1]]),
        Box::Solution.new(7, 5, [[3, 1]]),
        Box::Product.new(7, 48, [[4, 1], [5, 1], [6, 1]]),
        Box::Difference.new(7, 2, [[0, 2], [0, 3]]),
        Box::Sum.new(7, 11, [[1, 2], [1, 3], [1, 4]]),
        Box::Sum.new(7, 7, [[2, 2], [3, 2]]),
        Box::Sum.new(7, 12, [[4, 2], [4, 3], [5, 3]]),
        Box::Product.new(7, 14, [[5, 2], [6, 2]]),
        Box::Dividend.new(7, 2, [[2, 3], [3, 3]]),
        Box::Product.new(7, 3, [[6, 3], [5, 4], [6, 4]]),
        Box::Sum.new(7, 12, [[0, 4], [0, 5], [1, 5], [0, 6]]),
        Box::Sum.new(7, 18, [[2, 4], [3, 4], [4, 4]]),
        Box::Product.new(7, 42, [[2, 5], [3, 5], [4, 5]]),
        Box::Solution.new(7, 4, [[5, 5]]),
        Box::Difference.new(7, 2, [[6, 5], [6, 6]]),
        Box::Difference.new(7, 1, [[1, 6], [2, 6]]),
        Box::Product.new(7, 60, [[3, 6], [4, 6], [5, 6]])
      ]
      expect_solution boxes, [
        [2, 5, 6, 1, 7, 3, 4],
        [3, 7, 1, 5, 4, 2, 6],
        [5, 6, 4, 3, 1, 7, 2],
        [7, 3, 2, 4, 5, 6, 1],
        [4, 2, 5, 7, 6, 1, 3],
        [6, 1, 7, 2, 3, 4, 5],
        [1, 4, 3, 6, 2, 5, 7]
      ]
    end

    it "solves a puzzle with a solved cell at 0, 0" do
      boxes = [
        Box::Solution.new(7, 7, [[0, 0]]),
        Box::Sum.new(7, 12, [[1, 0], [2, 0], [0, 1], [1, 1]]),
        Box::Difference.new(7, 1, [[3, 0], [3, 1]]),
        Box::Product.new(7, 24, [[4, 0], [5, 0], [6, 0]]),
        Box::Sum.new(7, 21, [[2, 1], [0, 2], [1, 2], [2, 2]]),
        Box::Difference.new(7, 6, [[4, 1], [4, 2]]),
        Box::Dividend.new(7, 3, [[5, 1], [6, 1]]),
        Box::Product.new(7, 6, [[3, 2], [3, 3]]),
        Box::Difference.new(7, 1, [[5, 2], [6, 2]]),
        Box::Difference.new(7, 5, [[0, 3], [1, 3]]),
        Box::Sum.new(7, 12, [[2, 3], [2, 4], [2, 5]]),
        Box::Product.new(7, 105, [[4, 3], [5, 3], [6, 3]]),
        Box::Sum.new(7, 5, [[0, 4], [0, 5]]),
        Box::Sum.new(7, 12, [[1, 4], [1, 5]]),
        Box::Difference.new(7, 3, [[3, 4], [4, 4]]),
        Box::Sum.new(7, 14, [[5, 4], [6, 4], [6, 5]]),
        Box::Sum.new(7, 11, [[3, 5], [4, 5], [5, 5], [4, 6]]),
        Box::Difference.new(7, 1, [[0, 6], [1, 6]]),
        Box::Product.new(7, 6, [[2, 6], [3, 6]]),
        Box::Sum.new(7, 9, [[5, 6], [6, 6]]),
      ]
      expect_solution boxes, [
        [7, 3, 2, 5, 6, 4, 1],
        [5, 2, 6, 4, 7, 1, 3],
        [2, 6, 7, 3, 1, 5, 4],
        [6, 1, 4, 2, 3, 7, 5],
        [1, 5, 3, 7, 4, 6, 2],
        [4, 7, 5, 1, 2, 3, 6],
        [3, 4, 1, 6, 5, 2, 7]
      ]
    end

    # This is here because it catches errors in constructing puzzles,
    # but is also used in guessing
    it "returns nil if there is no solution because a box is unsolvable" do
      boxes = [Box::Solution.new(1, 2, [[0, 0]])]
      expect(Game.new(boxes).solution).to be_nil
    end

    it "returns nil if there is no solution because boxes are incompatible" do
      boxes = [
        Box::Solution.new(2, 1, [[0, 0]]),
        Box::Solution.new(2, 1, [[1, 0]]),
        Box::Solution.new(2, 1, [[0, 1]]),
        Box::Solution.new(2, 1, [[1, 1]])
      ]
      expect(Game.new(boxes).solution).to be_nil
    end

    def expect_solution(boxes, digits)
      expect(Game.new(boxes).solution.digits).to eq(digits)
    end
  end

  describe '#to_s' do
    it "includes each cell's possibilities" do
      boxes = [Box::Sum.new(2, 6, [[0, 0], [1, 0], [0, 1], [1, 1]])]
      expect(Game.new(boxes).to_s).to eq("[1, 2] [1, 2]\n[1, 2] [1, 2]\n")
    end
  end
end
