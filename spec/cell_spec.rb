require_relative '../lib/box'

RSpec.describe Cell do
  describe '#to_s' do
    it "includes the cell's possibilities" do
      box = Box.new 1, :+, 1, [[0, 0]]
      expect(Cell.new(box).to_s).to eq("#{box} [1]")
    end
  end
end
