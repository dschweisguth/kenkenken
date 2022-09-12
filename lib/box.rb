require_relative 'cell'

class Box
  attr_reader :cells, :grid_size

  def initialize(grid_size, op, result, locations)
    @grid_size = grid_size
    @op = op
    @result = result
    @cells = locations.map { |location| [location, Cell.new(self, op == :== ? result : nil)] }.to_h
  end

  def solve
    keys = @cells.keys
    if keys.length == 1
      @cells[keys.first].possibilities.replace [@result]
    end
  end
end
