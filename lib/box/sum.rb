require_relative 'base'

class Box::Sum < Box::Base
  def initialize(grid_size, result, locations)
    if locations.empty?
      raise "locations must contain >= 1 locations, but is empty"
    end
    super
  end

  def satisfies_constraint?(combo)
    combo.sum == @result
  end

  def operator
    '+'
  end
end
