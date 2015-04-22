class Defense < Building
  COOL_DOWN_MILISECONDS = 1000

  def monster_at_range?(monster)
    MapHelper.tiles_distance(center, monster.center) <= @range
  end

  def cooled_down?
    @last_shot_at.nil? or (@last_shot_at + COOL_DOWN_MILISECONDS) < Gosu::milliseconds
  end

  def shoot!(monster)
    if monster.health_points < @attack
      monster.health_points = 0
    else
      monster.health_points = monster.health_points - @attack
    end
    @last_shot_at = Gosu::milliseconds
  end

  private
    def center
      half_tile = MapHelper.tile_size / 2
      x = @cell.point.x
      y = @cell.point.y
      [x + half_tile, y + half_tile]
    end
end