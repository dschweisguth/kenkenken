require_relative '../cell'

module Box
end

class Box::Base
  attr_reader :result, :cells

  def initialize(grid_size, result, locations)
    @result = result
    initialize_cells(grid_size, locations)
  end

  private def initialize_cells(grid_size, locations)
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

  def solve
    combos = self.combos
    solvable_combos = combos.select { |combo| satisfies_constraint? combo }
    if solvable_combos.length == combos.length
      return false
    end
    solvable_combos.transpose.each_with_index.inject(false) do |progressed, (possibilities, i)|
      progressed | cells.values[i].restrict_to(possibilities.uniq)
    end
  end

  def copy
    dup.tap do |copy|
      copy.instance_variable_set '@cells', cells.transform_values(&:copy)
    end
  end

  def solvable?
    combos.any? { |combo| satisfies_constraint? combo }
  end

  private def combos
    product cells.values.map(&:possibilities)
  end

  private def product(arrays)
    if arrays.length == 1
      arrays.first.map { |digit| [digit] }
    else
      first, *rest = arrays
      first.product *rest
    end
  end

  def to_s
    "#{operator}#{result} { #{cells.map { |location, cell| "#{location} => #{cell}" }.join ", "} }"
  end
end
