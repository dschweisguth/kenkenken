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
    unsolved.possibilities.clear
    sum = solved_digit + @result
    if sum <= @grid_size
      unsolved.possibilities << sum
    end
    difference = solved_digit - @result
    if difference >= 1
      unsolved.possibilities << difference
    end
    true
  end
end
