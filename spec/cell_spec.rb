require_relative '../lib/cell'

RSpec.describe Cell do
  describe '.new' do
    it "raises if the solution is larger than the grid size" do
      box = Box.new 1, :+, 1, { [0, 0] => 1 }
      expect { Cell.new box, 2 }.to raise_error "solution 2 > grid_size 1"
    end
  end
end
