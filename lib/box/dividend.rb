require_relative 'base'

class Box::Dividend < Box::Base
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
    possibilities = [solved_digit * @result]
    div, mod = solved_digit.divmod @result
    if mod == 0
      possibilities << div
    end
    unsolved.restrict_to possibilities
  end

  def satisfies_constraint?(combo)
    dividend_equals_result(combo[0], combo[1]) || dividend_equals_result(combo[1], combo[0])
  end

  private def dividend_equals_result(a, b)
    div, mod = a.divmod b
    div == @result && mod == 0
  end

  def operator
    '÷'
  end
end
