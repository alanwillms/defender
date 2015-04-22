class Point
  attr_reader :x, :y, :z

  def initialize(x, y, z)
    if x < 0 or y < 0 or z < 0
      raise ArgumentError.new "Coordinates must be positive"
    end
    @x = x
    @y = y
    @z = z
  end
end