require_relative 'base'

class Box::Sum < Box::Base
  def solve
    solved_cells, unsolved_cells = @cells.values.partition &:solution
    if unsolved_cells.length != 1
      return false
    end
    remainder = @result - solved_cells.map { |cell| cell.solution }.sum
    unsolved_cells.first.solution = remainder
    true
  end
end
