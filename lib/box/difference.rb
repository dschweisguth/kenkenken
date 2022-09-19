require_relative 'base'

class Box::Difference < Box::Base
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
