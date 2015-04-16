class HealthBar
  PADDING = 2
  HEIGHT = 8
  BACKGROUND_COLOR = 0xff000000

  def initialize(health_points, initial_health_points, x, y)
    @health_points = health_points
    @initial_health_points = initial_health_points
    @x = x
    @y = y
  end

  def draw
    if @health_points == @initial_health_points
      return
    end

    width = MapHelper.tile_size
    x1 = @x
    y1 = @y
    x4 = @x + width
    y4 = @y + HEIGHT

    draw_bar(x1, y1, x4, y4, ZOrder::HealthBarBg, PADDING, BACKGROUND_COLOR)

    x4 = @x + (health_percent * width)

    draw_bar(x1, y1, x4, y4, ZOrder::HealthBar, PADDING + 1, health_color)
  end

  private
    def draw_bar(x1, y1, x4, y4, z, padding, color)
      x1 += padding
      x4 -= padding

      y1 += padding
      y4 -= padding

      if x4 < x1
        x4 = x1 + 1
      end

      x2 = x4
      y2 = y1
      x3 = x1
      y3 = y4

      #
      # x1,y1 ------- x2, y2
      #   |              |
      #   |              |
      #   |              |
      #   |              |
      # x3,y3 ------- x4,y4
      #
      Game.current_window.draw_quad(x1, y1, color, x2, y2, color, x3, y3, color, x4, y4, color, z)
    end

    def health_color
      if health_percent > 0.7
        return 0xff4caf50
      elsif health_percent > 0.3
        return 0xffffeb3b
      else
        return 0xfff44336
      end
    end

    def health_percent
      @health_percent ||= @health_points.to_f / @initial_health_points.to_f
    end
end