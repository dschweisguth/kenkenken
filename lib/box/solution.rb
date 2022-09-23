require_relative 'base'

class Box::Solution < Box::Base
  def initialize(grid_size, result, locations)
    if locations.length != 1
      raise "locations must contain 1 location, but contains #{locations.length}"
    end
    super
  end

  def solve
    @cells.first[1].restrict_to [@result]
  end
end
