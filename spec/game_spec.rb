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
        Box::Sum.new(3, 3, [[1, 2], [2, 2]])
      ]
      expect_solution boxes, [[1, 2, 3], [2, 3, 1], [3, 1, 2]]
    end

    # - - -   3 2 1
    # 4 - - → 1 3 2
    # 4 4 -   2 1 3
    it "rejects a guess with an unsolvable box, size 3" do
      boxes = [
        Box::Sum.new(3,  4, [[0, 0], [1, 0], [0, 1]]),
        Box::Sum.new(3, 14, [[2, 0], [1, 1], [2, 1], [0, 2], [1, 2], [2, 2]])
      ]
      expect_solution boxes, [[2, 1, 3], [1, 3, 2], [3, 2, 1]]
    end

    #  3  3 10 10   1 2 3 4
    # 13  3  3 10 → 4 1 2 3
    # 13 13  4  4 → 3 4 1 2
    # 13  7  7  4   2 3 4 1
    it "rejects a guess with an unsolvable box, size 4" do
      boxes = [
        Box::Sum.new(4, 13, [[0, 0], [0, 1], [1, 1], [0, 2]]),
        Box::Sum.new(4,  7, [[1, 0], [2, 0]]),
        Box::Sum.new(4,  4, [[3, 0], [2, 1], [3, 1]]),
        Box::Sum.new(4,  3, [[1, 2], [2, 2]]),
        Box::Sum.new(4, 10, [[3, 2], [2, 3], [3, 3]]),
        Box::Sum.new(4,  3, [[0, 3], [1, 3]])
      ]
      expect_solution boxes, [[2, 3, 4, 1], [3, 4, 1, 2], [4, 1, 2, 3], [1, 2, 3, 4]]
    end

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

    it "returns nil if there is no solution" do
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
