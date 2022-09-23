require_relative '../../lib/box/solution'

RSpec.describe Box::Solution do
  describe '.new' do
    it "rejects != 1 locations" do
      expect { Box::Solution.new 1, 1, [] }.to raise_error "locations must contain 1 location, but contains 0"
    end
  end

  describe '#solve' do
    it "solves an unsolved cell" do
      box = Box::Solution.new 2, 1, [[0, 0]]
      eliminated_something = box.solve
      expect(eliminated_something).to be_truthy
      expect(box.cells[[0, 0]].solution).to eq(1)
    end

    it "returns false if no possibilities were eliminated" do
      box = Box::Solution.new 1, 1, [[0, 0]]
      eliminated_something = box.solve
      expect(eliminated_something).to be_falsey
      expect(box.cells[[0, 0]].solution).to eq(1)
    end
  end
end
