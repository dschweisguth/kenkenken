require_relative 'base'

class Box::Sum < Box::Base
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
    remainder = @result - solved_cells.map { |cell| cell.solution }.sum
    unsolved_cells.first.restrict_to [remainder]
  end
end
