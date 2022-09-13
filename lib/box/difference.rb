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
    possibilities = []
    solved_digit = solved.solution
    sum = solved_digit + @result
    if sum <= @grid_size
      possibilities << sum
    end
    difference = solved_digit - @result
    if difference >= 1
      possibilities << difference
    end
    unsolved.possibilities = possibilities
    true
  end
end
