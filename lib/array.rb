class Array
  def self.product(arrays)
    if arrays.length == 1
      arrays.first.map { |digit| [digit] }
    else
      first, *rest = arrays
      first.product *rest
    end
  end
end
