class Cell
  attr_reader :possibilities

  def initialize(grid_size)
    @possibilities = (1..grid_size).to_a
  end

  def solution
    possibilities.length == 1 ? possibilities.first : nil
  end

  def restrict_to(digits)
    intersection = possibilities & digits
    if intersection.any? && possibilities != intersection
      possibilities.replace intersection
      true
    else
      false
    end
  end

  def eliminate(digit)
    possibilities.length > 1 && possibilities.delete(digit)
  end

  def unsolved_possibilities
    possibilities.length == 1 ? [] : possibilities
  end

  def copy
    dup.tap do |copy|
      copy.instance_variable_set '@possibilities', possibilities.dup
    end
  end

  def to_s
    possibilities.inspect
  end
end
