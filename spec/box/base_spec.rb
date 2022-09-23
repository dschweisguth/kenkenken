require_relative '../../lib/box/base'

RSpec.describe Box::Base do
  describe '.new' do
    it "rejects duplicate cells" do
      expect { Box::Base.new 2, 1, [[0, 0], [0, 0]] }.to raise_error "Two cells are at the same location, [0, 0]"
    end
  end
end
