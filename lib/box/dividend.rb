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
    possibilities = []
    solved_digit = solved.solution
    product = solved_digit * @result
    if product <= @grid_size
      possibilities << product
    end
    div, mod = solved_digit.divmod @result
    if div >= 1 && mod == 0
      possibilities << div
    end
    unsolved.possibilities = possibilities
    true
  end
end
