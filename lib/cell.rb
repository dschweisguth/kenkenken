class Cell
  attr_reader :possibilities

  def initialize(box, possibilities)
    @box = box
    @possibilities = possibilities
  end
end
