require_relative '../../lib/box/sum'

RSpec.describe Box::Sum do
  describe '.new' do
    it "rejects 0 locations" do
      expect { Box::Sum.new 1, 1, [] }.to raise_error "locations must contain >= 1 locations, but is empty"
    end
  end

  describe '#solve' do
    it "solves a one-cell box" do
      box = Box::Sum.new 2, 1, [[0, 0]]
      eliminated_something = box.solve
      expect(eliminated_something).to be_truthy
      expect(box.cells[[0, 0]].solution).to eq(1)
    end

    it "solves a two-cell box" do
      box = Box::Sum.new 2, 3, [[0, 0], [1, 0]]
      box.cells[[0, 0]].restrict_to [1]
      eliminated_something = box.solve
      expect(eliminated_something).to be_truthy
      expect(box.cells[[1, 0]].solution).to eq(2)
    end

    it "returns false if no possibilities were eliminated" do
      box = Box::Sum.new 1, 1, [[0, 0]]
      eliminated_something = box.solve
      expect(eliminated_something).to be_falsey
      expect(box.cells[[0, 0]].solution).to eq(1)
    end
  end
end
