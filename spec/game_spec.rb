require_relative '../lib/game'

RSpec.describe Game do
  describe '#solve' do
    it "solves the simplest game" do
      expect(Game.new([Box.new(:==, 1, [[0, 0]])]).solution.digits).to eq([[1]])
    end
  end
end
