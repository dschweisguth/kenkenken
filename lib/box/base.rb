require_relative '../cell'

module Box
end

class Box::Base
  attr_reader :grid_size, :result, :cells

  def initialize(grid_size, result, locations)
    @grid_size = grid_size
    @result = result
    initialize_cells(locations)
  end

  private def initialize_cells(locations)
    @cells = {}
    locations.each do |location|
      if location[0] < 0 || grid_size <= location[0]
        raise "Location #{location.inspect} x is off the grid"
      end
      if location[1] < 0 || grid_size <= location[1]
        raise "Location #{location.inspect} y is off the grid"
      end
      if @cells[location]
        raise "Two cells are at the same location, #{location.inspect}"
      end
      @cells[location] = Cell.new grid_size
    end
  end

  def copy
    dup.tap do |copy|
      copy.instance_variable_set '@cells', cells.transform_values(&:copy)
    end
  end

  def solvable?
    possibilities = cells.values.map(&:possibilities)
    combos =
      if possibilities.length == 1
        possibilities.first.map { |digit| [digit] }
      else
        first, *rest = possibilities
        first.product *rest
      end
    combos.any? { |combo| satisfies_constraint? combo }
  end

  def to_s
    "#{operator}#{result} { #{cells.map { |location, cell| "#{location} => #{cell}" }.join ", "} }"
  end
end
