class Cell
  attr_reader :possibilities

  def initialize(box, solution)
    @box = box
    @possibilities =
      if solution
        [solution]
      else
        (1..box.grid_size).to_a
      end
  end

  def solution
    possibilities.length == 1 ? possibilities.first : nil
  end
end
