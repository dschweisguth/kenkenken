require_relative '../../lib/box/sum'

RSpec.describe Box::Sum do
  describe '.new' do
    it "rejects 0 locations" do
      expect { box 1, 1, [] }.to raise_error "locations must contain >= 1 locations, but is empty"
    end
  end

  describe '#resolve' do
    it "resolves a one-cell box" do
      box = box 2, 1, [[0, 0]]
      progressed = box.resolve
      expect(progressed).to be_truthy
      expect(box.cells[[0, 0]].solution).to eq(1)
    end

    it "resolves a two-cell box" do
      box = box 2, 3, [[0, 0], [1, 0]]
      box.cells[[0, 0]].restrict_to [1]
      progressed = box.resolve
      expect(progressed).to be_truthy
      expect(box.cells[[1, 0]].solution).to eq(2)
    end

    it "eliminates duplicates in rows" do
      box = box 3, 4, [[0, 0], [0, 1]]
      progressed = box.resolve
      expect(progressed).to be_truthy
      expect(box.cells.values.map &:possibilities).to eq([[1, 3], [1, 3]])
    end

    it "eliminates duplicates in columns" do
      box = box 3, 4, [[0, 0], [1, 0]]
      progressed = box.resolve
      expect(progressed).to be_truthy
      expect(box.cells.values.map &:possibilities).to eq([[1, 3], [1, 3]])
    end

    it "returns false if no possibilities were eliminated" do
      box = box 1, 1, [[0, 0]]
      progressed = box.resolve
      expect(progressed).to be_falsey
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
