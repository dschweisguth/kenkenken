require_relative 'cell'

class Box
  attr_reader :cells, :grid_size

  def initialize(grid_size, op, result, locations)
    @grid_size = grid_size
    @op = op
    @result = result
    @cells = locations.map { |location| [location, Cell.new(self)] }.to_h
  end

  def solve
    case @op
      when :==
        if @cells.first[1].solution
          false
        else
          @cells.first[1].solution = @result
          true
        end
      when :+
        solved_cells, unsolved_cells = @cells.partition { |_, cell| cell.solution }
        if unsolved_cells.length == 1
          remainder = @result - solved_cells.map { |_, cell| cell.possibilities.first }.sum
          unsolved_cells.first[1].solution = remainder
          true
        else
          false
        end
      when :-
        solved_cells, unsolved_cells = @cells.partition { |_, cell| cell.solution }
        if unsolved_cells.length == 1
          solved_digit = solved_cells.first[1].solution
          unsolved_possibilities =
            [solved_digit + @result, solved_digit - @result].
              reject { |digit| digit < 1 || @grid_size < digit }
          unsolved_cells.first[1].possibilities.replace unsolved_possibilities
          true
        else
          false
        end
    end
  end
end
