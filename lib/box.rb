require_relative 'cell'

class Box
  attr_reader :cells

  def initialize(op, result, locations)
    @op = op
    @result = result
    @cells = locations.map { |location| [location, Cell.new(self, [result])] }.to_h
  end
end
