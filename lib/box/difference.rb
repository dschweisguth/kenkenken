require_relative 'base'

class Box::Difference < Box::Base
  def initialize(grid_size, result, locations)
    if locations.length != 2
      raise "locations must contain 2 locations, but contains #{locations.length}"
    end
    super
  end

  def solve
    solved, unsolved = @cells.values
    if !solved.solution || unsolved.solution
      solved, unsolved = unsolved, solved
    end
    if !solved.solution || unsolved.solution
      return false
    end
    solved_digit = solved.solution
    unsolved.restrict_to [solved_digit + @result, solved_digit - @result]
  end
end
