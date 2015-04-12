class Defense < Building
  def initialize(map, row, column)
    super(map, row, column)
    @range = 4
  end

  def at_range?(monster)
  end
end