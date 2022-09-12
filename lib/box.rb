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
    if @op == :+
      solved_cells, unsolved_cells = @cells.partition { |_, cell| cell.solution }
      if unsolved_cells.length == 1
        remainder = @result - solved_cells.map { |_, cell| cell.possibilities.first }.sum
        unsolved_cells.first[1].solution = remainder
        true
      else
        false
      end
    else
      false
    end
  end
end
