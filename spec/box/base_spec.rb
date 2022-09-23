require_relative '../../lib/box/base'

RSpec.describe Box::Base do
  describe '.new' do
    it "rejects x < 0" do
      expect { Box::Base.new 1, 1, [[-1, 0]] }.to raise_error "Location [-1, 0] x is off the grid"
    end

    it "rejects x >= grid_size" do
      expect { Box::Base.new 1, 1, [[1, 0]] }.to raise_error "Location [1, 0] x is off the grid"
    end

    it "rejects y < 0" do
      expect { Box::Base.new 1, 1, [[0, -1]] }.to raise_error "Location [0, -1] y is off the grid"
    end

    it "rejects y >= grid_size" do
      expect { Box::Base.new 1, 1, [[0, 1]] }.to raise_error "Location [0, 1] y is off the grid"
    end

    it "rejects duplicate cells" do
      expect { Box::Base.new 2, 1, [[0, 0], [0, 0]] }.to raise_error "Two cells are at the same location, [0, 0]"
    end
  end
end
