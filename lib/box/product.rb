require_relative 'base'

class Box::Product < Box::Base
  def initialize(grid_size, result, locations)
    if locations.empty?
      raise "locations must contain >= 1 locations, but is empty"
    end
    super
  end

  def solve
    solved_cells, unsolved_cells = @cells.values.partition &:solution
    if unsolved_cells.length != 1
      return false
    end
    dividend = @result / solved_cells.map { |cell| cell.solution }.inject(1, :*)
    unsolved_cells.first.restrict_to [dividend]
  end

  def satisfies_constraint?(combo)
    combo.inject(:*) == @result
  end

  def operator
    '×'
  end
end
