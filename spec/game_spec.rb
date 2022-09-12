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
      expect_solution 1, :==, 1, [[0, 0]], [[1]]
    end

    it "solves the simplest unsolved game" do
      expect_solution 1, :+, 1, [[0, 0]], [[1]]
    end

    def expect_solution(grid_size, op, result, locations, digits)
      expect(Game.new([Box.new(grid_size, op, result, locations)]).solution.digits).to eq(digits)
    end
  end
end
