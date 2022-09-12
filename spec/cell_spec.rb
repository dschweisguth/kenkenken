require_relative '../lib/box'

RSpec.describe Cell do
  describe '.new' do
    it "raises if the solution is larger than the grid size" do
      box = Box.new 1, :+, 1, [[0, 0]]
      expect { Cell.new box, 2 }.to raise_error "solution 2 > grid_size 1"
    end
  end

  describe '#to_s' do
    it "includes the cell's possibilities" do
      box = Box.new 1, :+, 1, [[0, 0]]
      expect(Cell.new(box, 1).to_s).to eq("#{box} [1]")
    end
  end
end
