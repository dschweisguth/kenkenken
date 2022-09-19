require_relative 'base'

class Box::Dividend < Box::Base
  def solve
    solved, unsolved = @cells.values
    if !solved.solution || unsolved.solution
      solved, unsolved = unsolved, solved
    end
    if !solved.solution || unsolved.solution
      return false
    end
    solved_digit = solved.solution
    possibilities = [solved_digit * @result]
    div, mod = solved_digit.divmod @result
    if mod == 0
      possibilities << div
    end
    unsolved.restrict_to possibilities
  end
end
