require_relative 'base'

class Box::Difference < Box::Base
  def initialize(grid_size, result, locations)
    if locations.length != 2
      raise "locations must contain 2 locations, but contains #{locations.length}"
    end
    super
  end

  def satisfies_constraint?(combo)
    (combo[0] - combo[1]).abs == @result
  end

  def operator
    '-'
  end
end
