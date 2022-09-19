class Cell
  attr_reader :possibilities

  def initialize(box)
    @box = box
    @possibilities = (1..box.grid_size).to_a
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
    possibilities.delete(digit).tap do
      if possibilities.empty?
        raise "No possible solutions remain"
      end
    end
  end

  def to_s
    "#{@box} #{possibilities.inspect}"
  end
end
