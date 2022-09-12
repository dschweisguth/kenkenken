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
    unsolved.possibilities.clear
    product = solved_digit * @result
    if product <= @grid_size
      unsolved.possibilities << product
    end
    div, mod = solved_digit.divmod @result
    if div >= 1 && mod == 0
      unsolved.possibilities << div
    end
    true
  end
end
