require_relative 'base'

class Box::Sum < Box::Base
  def solve
    solved_cells, unsolved_cells = @cells.partition { |_, cell| cell.solution }
    if unsolved_cells.length != 1
      return false
    end
    remainder = @result - solved_cells.map { |_, cell| cell.possibilities.first }.sum
    unsolved_cells.first[1].solution = remainder
    true
  end
end
