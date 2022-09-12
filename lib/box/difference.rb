require_relative 'base'

class Box::Difference < Box::Base
  def solve
    solved_cells, unsolved_cells = @cells.partition { |_, cell| cell.solution }
    if unsolved_cells.length != 1
      return false
    end
    solved_digit = solved_cells.first[1].solution
    unsolved_possibilities =
      [solved_digit + @result, solved_digit - @result].
        reject { |digit| digit < 1 || @grid_size < digit }
    unsolved_cells.first[1].possibilities.replace unsolved_possibilities
    true
  end
end
