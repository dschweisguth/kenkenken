require_relative '../../lib/box/dividend'

RSpec.describe Box::Dividend do
  describe '.new' do
    it "rejects != 2 locations" do
      expect { Box::Dividend.new 1, 1, [] }.to raise_error "locations must contain 2 locations, but contains 0"
    end
  end

  describe '#solve' do
    it "solves an unsolved cell > solved cell" do
      box = Box::Dividend.new 2, 2, [[0, 0], [1, 0]]
      box.cells[[0, 0]].restrict_to [1]
      eliminated_something = box.solve
      expect(eliminated_something).to be_truthy
      expect(box.cells[[1, 0]].solution).to eq(2)
    end

    it "solves an unsolved cell > solved cell" do
      box = Box::Dividend.new 2, 2, [[0, 0], [1, 0]]
      box.cells[[0, 0]].restrict_to [2]
      eliminated_something = box.solve
      expect(eliminated_something).to be_truthy
      expect(box.cells[[1, 0]].solution).to eq(1)
    end

    it "returns false if no possibilities were eliminated" do
      box = Box::Dividend.new 2, 2, [[0, 0], [1, 0]]
      box.cells[[0, 0]].restrict_to [1]
      box.cells[[1, 0]].restrict_to [2]
      eliminated_something = box.solve
      expect(eliminated_something).to be_falsey
      expect(box.cells[[1, 0]].solution).to eq(2)
    end
  end
end