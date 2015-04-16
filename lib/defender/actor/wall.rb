class Wall < Building
  def initialize(map, row, column)
    super(map, row, column, :wall)
  end
end