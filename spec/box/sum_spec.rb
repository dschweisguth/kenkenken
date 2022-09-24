require_relative '../../lib/box/sum'

RSpec.describe Box::Sum do
  describe '.new' do
    it "rejects 0 locations" do
      expect { box 1, 1, [] }.to raise_error "locations must contain >= 1 locations, but is empty"
    end
  end

  describe '#solve' do
    it "solves a one-cell box" do
      box = box 2, 1, [[0, 0]]
      eliminated_something = box.solve
      expect(eliminated_something).to be_truthy
      expect(box.cells[[0, 0]].solution).to eq(1)
    end

    it "solves a two-cell box" do
      box = box 2, 3, [[0, 0], [1, 0]]
      box.cells[[0, 0]].restrict_to [1]
      eliminated_something = box.solve
      expect(eliminated_something).to be_truthy
      expect(box.cells[[1, 0]].solution).to eq(2)
    end

    it "returns false if no possibilities were eliminated" do
      box = box 1, 1, [[0, 0]]
      eliminated_something = box.solve
      expect(eliminated_something).to be_falsey
      expect(box.cells[[0, 0]].solution).to eq(1)
    end
  end

  describe '#solvable?' do
    it "returns true if a combination of possibilities satisfies the constraint, 1 cell, 1 possibility" do
      box = box 1, 1, [[0, 0]]
      expect(box).to be_solvable
    end

    it "returns true if a combination of possibilities satisfies the constraint, 1 cell, 2 possibilities" do
      box = box 2, 1, [[0, 0]]
      expect(box).to be_solvable
    end

    it "returns true if a combination of possibilities satisfies the constraint, 2 cells" do
      box = box 2, 3, [[0, 0], [1, 0]]
      expect(box).to be_solvable
    end

    it "returns false if no combination of possibilities satisfies the constraint" do
      box = box 1, 2, [[0, 0]]
      expect(box).not_to be_solvable
    end
  end

  describe '#to_s' do
    it "includes operator, result and cells" do
      box = box 1, 1, [[0, 0]]
      expect(box.to_s).to eq("+1 { [0, 0] => [1] }")
    end
  end

  def box(grid_size, result, locations)
    Box::Sum.new grid_size, result, locations
  end
end
