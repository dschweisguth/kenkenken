require_relative '../lib/box/sum'

RSpec.describe Cell do
  describe '#restrict_to' do
    let(:cell) do
      box = Box::Sum.new 2, 3, [[0, 0], [1, 0]]
      box.cells[[0, 0]]
    end

    it "restricts possibilities to the given digits and returns true" do
      expect(cell.restrict_to([1])).to be_truthy
      expect(cell.possibilities).to eq([1])
    end

    it "ignores a digit that is not a possibility" do
      expect(cell.restrict_to([1, 3])).to be_truthy
      expect(cell.possibilities).to eq([1])
    end

    it "does nothing and returns false if restricting digits would leave no possibilities" do
      expect(cell.restrict_to([3])).to be_falsey
      expect(cell.possibilities).to eq([1, 2])
    end

    it "does nothing and returns false if no digits would be eliminated" do
      expect(cell.restrict_to([1, 2])).to be_falsey
      expect(cell.possibilities).to eq([1, 2])
    end

    it "does nothing and returns false regardless of the order of the given digits" do
      expect(cell.restrict_to([2, 1])).to be_falsey
      expect(cell.possibilities).to eq([1, 2])
    end
  end

  describe '#to_s' do
    it "includes the cell's possibilities" do
      box = Box::Sum.new 1, 1, [[0, 0]]
      expect(Cell.new(box).to_s).to eq("#{box} [1]")
    end
  end
end
