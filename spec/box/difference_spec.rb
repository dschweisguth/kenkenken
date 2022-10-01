require_relative '../../lib/box/difference'

RSpec.describe Box::Difference do
  describe '.new' do
    it "rejects != 2 locations" do
      expect { box 1, 1, [] }.to raise_error "locations must contain 2 locations, but contains 0"
    end
  end

  describe '#resolve' do
    it "resolves an unsolved cell > solved cell" do
      box = box 2, 1, [[0, 0], [1, 0]]
      box.cells[[0, 0]].restrict_to [1]
      progressed = box.resolve
      expect(progressed).to be_truthy
      expect(box.cells[[1, 0]].solution).to eq(2)
    end

    it "resolves an unsolved cell < solved cell" do
      box = box 2, 1, [[0, 0], [1, 0]]
      box.cells[[0, 0]].restrict_to [2]
      progressed = box.resolve
      expect(progressed).to be_truthy
      expect(box.cells[[1, 0]].solution).to eq(1)
    end

    it "returns false if no possibilities were eliminated" do
      box = box 2, 1, [[0, 0], [1, 0]]
      box.cells[[0, 0]].restrict_to [1]
      box.cells[[1, 0]].restrict_to [2]
      progressed = box.resolve
      expect(progressed).to be_falsey
      expect(box.cells[[1, 0]].solution).to eq(2)
    end
  end

  describe '#solvable?' do
    it "returns true if a combination of possibilities satisfies the constraint" do
      box = box 2, 1, [[0, 0], [1, 0]]
      expect(box).to be_solvable
    end

    it "returns false if no combination of possibilities satisfies the constraint" do
      box = box 2, 2, [[0, 0], [1, 0]]
      expect(box).not_to be_solvable
    end
  end

  describe '#to_s' do
    it "includes operator, result and cells" do
      box = box 2, 1, [[0, 0], [1, 0]]
      expect(box.to_s).to eq("-1 { [0, 0] => [1, 2], [1, 0] => [1, 2] }")
    end
  end

  def box(grid_size, result, locations)
    Box::Difference.new grid_size, result, locations
  end
end
