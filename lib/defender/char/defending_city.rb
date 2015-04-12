class DefendingCity
  attr_accessor :health_points

  def initialize(map)
    @map = map
    @health_points = 100
  end

  def draw(x, y, z)
    SpriteHelper.image(:defending_city).draw(x, y, z)
  end
end