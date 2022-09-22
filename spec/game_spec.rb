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
      expect { Game.new boxes }.to raise_error "Grid size is 2, but #{boxes.first} has grid size 3"
    end
  end

  describe '#solution' do
    it "solves the simplest game" do
      boxes = [Box::Solution.new(1, 1, [[0, 0]])]
      expect_solution boxes, [[1]]
    end

    it "solves the simplest unsolved game" do
      boxes = [Box::Sum.new(1, 1, [[0, 0]])]
      expect_solution boxes, [[1]]
    end

    it "solves the next simplest unsolved game" do
      boxes = [
        Box::Solution.new(2, 1, [[0, 0]]),
        Box::Sum.new(2, 5, [[1, 0], [0, 1], [1, 1]])
      ]
      expect_solution boxes, [[1, 2], [2, 1]]
    end

    it "solves a game that requires repeated elimination of possibilities" do
      boxes = [
        Box::Solution.new(2, 1, [[1, 1]]),
        Box::Sum.new(2, 5, [[0, 0], [1, 0], [0, 1]])
      ]
      expect_solution boxes, [[1, 2], [2, 1]]
    end

    it "handles a sum box with one cell" do
      boxes = [
        Box::Sum.new(2, 1, [[0, 0]]),
        Box::Sum.new(2, 5, [[1, 0], [0, 1], [1, 1]])
      ]
      expect_solution boxes, [[1, 2], [2, 1]]
    end

    it "handles a sum box with more than one cell" do
      boxes = [
        Box::Solution.new(3, 1, [[0, 0]]),
        Box::Solution.new(3, 2, [[1, 0]]),
        Box::Sum.new(3, 5, [[2, 0], [2, 1]]),
        Box::Sum.new(3, 10, [[0, 1], [1, 1], [0, 2], [1, 2], [2, 2]])
      ]
      expect_solution boxes, [[1, 2, 3], [3, 1, 2], [2, 3, 1]]
    end

    it "handles a difference box, solved digit > unsolved digit" do
      boxes = [
        Box::Solution.new(3, 1, [[0, 0]]),
        Box::Solution.new(3, 2, [[1, 0]]),
        Box::Difference.new(3, 1, [[2, 0], [2, 1]]),
        Box::Sum.new(3, 10, [[0, 1], [1, 1], [0, 2], [1, 2], [2, 2]])
      ]
      expect_solution boxes, [[1, 2, 3], [3, 1, 2], [2, 3, 1]]
    end

    it "handles a difference box, unsolved digit > solved digit" do
      boxes = [
        Box::Solution.new(3, 2, [[0, 0]]),
        Box::Solution.new(3, 3, [[1, 0]]),
        Box::Difference.new(3, 1, [[2, 0], [2, 1]]),
        Box::Sum.new(3, 10, [[0, 1], [1, 1], [0, 2], [1, 2], [2, 2]])
      ]
      expect_solution boxes, [[2, 3, 1], [3, 1, 2], [1, 2, 3]]
    end

    it "handles a product box with one cell" do
      boxes = [
        Box::Product.new(2, 1, [[0, 0]]),
        Box::Product.new(2, 4, [[1, 0], [0, 1], [1, 1]])
      ]
      expect_solution boxes, [[1, 2], [2, 1]]
    end

    it "handles a product box with more than one cell" do
      boxes = [
        Box::Solution.new(3, 1, [[0, 0]]),
        Box::Solution.new(3, 2, [[1, 0]]),
        Box::Product.new(3, 6, [[2, 0], [2, 1]]),
        Box::Sum.new(3, 10, [[0, 1], [1, 1], [0, 2], [1, 2], [2, 2]])
      ]
      expect_solution boxes, [[1, 2, 3], [3, 1, 2], [2, 3, 1]]
    end

    it "handles a dividend box, solved digit > unsolved digit" do
      boxes = [
        Box::Solution.new(3, 1, [[0, 0]]),
        Box::Solution.new(3, 2, [[1, 0]]),
        Box::Dividend.new(3, 3, [[2, 0], [2, 1]]),
        Box::Sum.new(3, 10, [[0, 1], [1, 1], [0, 2], [1, 2], [2, 2]])
      ]
      expect_solution boxes, [[1, 2, 3], [2, 3, 1], [3, 1, 2]]
    end

    it "handles a dividend box, unsolved digit > solved digit" do
      boxes = [
        Box::Solution.new(3, 2, [[0, 0]]),
        Box::Solution.new(3, 3, [[1, 0]]),
        Box::Dividend.new(3, 3, [[2, 0], [2, 1]]),
        Box::Sum.new(3, 10, [[0, 1], [1, 1], [0, 2], [1, 2], [2, 2]])
      ]
      expect_solution boxes, [[2, 3, 1], [1, 2, 3], [3, 1, 2]]
    end

    # 5 3 3   3 1 2
    # 5 4 4 → 2 3 1
    # 1 2 3   1 2 3
    it "guesses" do
      boxes = [
        Box::Solution.new(3, 1, [[0, 0]]),
        Box::Solution.new(3, 2, [[1, 0]]),
        Box::Solution.new(3, 3, [[2, 0]]),
        Box::Sum.new(3, 5, [[0, 1], [0, 2]]),
        Box::Sum.new(3, 4, [[1, 1], [2, 1]]),
        Box::Sum.new(3, 4, [[1, 2], [2, 2]])
      ]
      expect_solution boxes, [[1, 2, 3], [2, 3, 1], [3, 1, 2]]
    end

    it "raises if a cell's last possibility is eliminated" do
      boxes = [
        Box::Solution.new(2, 1, [[0, 0]]),
        Box::Solution.new(2, 1, [[1, 0]]),
        Box::Solution.new(2, 1, [[0, 1]]),
        Box::Solution.new(2, 1, [[1, 1]])
      ]
      expect { Game.new(boxes).solution }.to raise_error "No possible solutions remain"
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
