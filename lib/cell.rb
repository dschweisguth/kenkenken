class Cell
  attr_reader :possibilities

  def initialize(box)
    @box = box
    @possibilities = (1..box.grid_size).to_a
  end

  def solution
    possibilities.length == 1 ? possibilities.first : nil
  end

  def solution=(digit)
    possibilities.replace [digit]
  end

  def eliminate(digit)
    possibilities.delete(digit).tap do
      if possibilities.empty?
        raise "No possible solutions remain"
      end
    end
  end

  def possibilities=(possibilities)
    @possibilities.replace possibilities
  end

  def to_s
    "#{@box} #{possibilities.inspect}"
  end
end
