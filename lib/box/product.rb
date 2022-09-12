require_relative 'base'

class Box::Product < Box::Base
  def solve
    solved_cells, unsolved_cells = @cells.values.partition &:solution
    if unsolved_cells.length != 1
      return false
    end
    dividend = @result / solved_cells.map { |cell| cell.solution }.inject(1, :*)
    unsolved_cells.first.solution = dividend
    true
  end
end
