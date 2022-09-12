require_relative 'base'

class Box::Solution < Box::Base
  def solve
    cell = @cells.first[1]
    if cell.solution
      false
    else
      cell.solution = @result
      true
    end
  end
end
