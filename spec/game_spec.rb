require_relative '../lib/game'

RSpec.describe Game do
  describe '.new' do
    it "raises if the given boxes don't form a square" do
      box = Box.new 2, :+, 3, [[0, 0], [1, 0]]
      expect { Game.new [box] }.to raise_error "Grid is 1 cells high but row 0 is 2 cells wide"
    end

    it "raises if a cell is in more than one box" do
      boxes = [Box.new(1, :==, 1, [[0, 0]]), Box.new(1, :==, 1, [[0, 0]])]
      expect { Game.new boxes }.to raise_error "Cell 0, 0 is in more than one box"
    end
  end

  describe '#solution' do
    it "solves the simplest game" do
      boxes = [Box.new(1, :==, 1, [[0, 0]])]
      expect_solution boxes, [[1]]
    end

    it "solves the simplest unsolved game" do
      boxes = [Box.new(1, :+, 1, [[0, 0]])]
      expect_solution boxes, [[1]]
    end

    it "solves the next simplest unsolved game" do
      boxes = [Box.new(2, :==, 1, [[0, 0]]), Box.new(2, :+, 5, [[1, 0], [0, 1], [1, 1]])]
      expect_solution boxes, [[1, 2], [2, 1]]
    end

    it "solves a game that requires repeated elimination of possibilities" do
      boxes = [Box.new(2, :==, 1, [[1, 1]]), Box.new(2, :+, 5, [[0, 0], [1, 0], [0, 1]])]
      expect_solution boxes, [[1, 2], [2, 1]]
    end

    it "handles an addition box with one cell" do
      boxes = [Box.new(2, :+, 1, [[0, 0]]), Box.new(2, :+, 5, [[1, 0], [0, 1], [1, 1]])]
      expect_solution boxes, [[1, 2], [2, 1]]
    end

    it "handles an addition box with more than one cell" do
      boxes = [
        Box.new(3, :==, 1, [[0, 0]]),
        Box.new(3, :==, 2, [[1, 0]]),
        Box.new(3, :+, 5, [[2, 0], [2, 1]]),
        Box.new(3, :+, 10, [[0, 1], [1, 1], [0, 2], [1, 2], [2, 2]])
      ]
      expect_solution boxes, [[1, 2, 3], [3, 1, 2], [2, 3, 1]]
    end

    it "handles a subtraction box, solved digit > unsolved digit" do
      boxes = [
        Box.new(3, :==, 1, [[0, 0]]),
        Box.new(3, :==, 2, [[1, 0]]),
        Box.new(3, :-, 1, [[2, 0], [2, 1]]),
        Box.new(3, :+, 10, [[0, 1], [1, 1], [0, 2], [1, 2], [2, 2]])
      ]
      expect_solution boxes, [[1, 2, 3], [3, 1, 2], [2, 3, 1]]
    end

    it "handles a subtraction box, unsolved digit > solved digit" do
      boxes = [
        Box.new(3, :==, 2, [[0, 0]]),
        Box.new(3, :==, 3, [[1, 0]]),
        Box.new(3, :-, 1, [[2, 0], [2, 1]]),
        Box.new(3, :+, 10, [[0, 1], [1, 1], [0, 2], [1, 2], [2, 2]])
      ]
      expect_solution boxes, [[2, 3, 1], [3, 1, 2], [1, 2, 3]]
    end

    def expect_solution(boxes, digits)
      expect(Game.new(boxes).solution.digits).to eq(digits)
    end
  end
end
