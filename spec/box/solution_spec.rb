require_relative '../../lib/box/solution'

RSpec.describe Box::Solution do
  describe '.new' do
    it "rejects != 1 locations" do
      expect { box 1, 1, [] }.to raise_error "locations must contain 1 location, but contains 0"
    end
  end

  describe '#solve' do
    it "solves an unsolved cell" do
      box = box 2, 1, [[0, 0]]
      eliminated_something = box.solve
      expect(eliminated_something).to be_truthy
      expect(box.cells[[0, 0]].solution).to eq(1)
    end

    it "returns false if no possibilities were eliminated" do
      box = box 1, 1, [[0, 0]]
      eliminated_something = box.solve
      expect(eliminated_something).to be_falsey
      expect(box.cells[[0, 0]].solution).to eq(1)
    end
  end

  describe '#solvable?' do
    it "returns true if a possibility satisfies the constraint, 1 possibility" do
      box = box 1, 1, [[0, 0]]
      expect(box).to be_solvable
    end

    it "returns true if a possibility satisfies the constraint, 2 possibilities" do
      box = box 2, 2, [[0, 0]]
      expect(box).to be_solvable
    end
  end

  describe '#to_s' do
    it "includes operator, result and cells" do
      box = box 1, 1, [[0, 0]]
      expect(box.to_s).to eq("=1 { [0, 0] => [1] }")
    end
  end

  def box(grid_size, result, locations)
    Box::Solution.new grid_size, result, locations
  end
end
