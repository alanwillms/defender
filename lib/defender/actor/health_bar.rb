class HealthBar
  BACKGROUND_COLOR = 0xff000000
  GOOD_HEALTH_COLOR = 0xff4caf50
  MEDIUM_HEALTH_COLOR = 0xffffeb3b
  BAD_HEALTH_COLOR = 0xfff44336

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
    y4 = @y + Game.config[:health_bar_height]

    draw_bar(x1, y1, x4, y4, ZOrder::HealthBarBg, Game.config[:health_bar_padding], BACKGROUND_COLOR)

    x4 = @x + (health_percent * width)

    draw_bar(x1, y1, x4, y4, ZOrder::HealthBar, Game.config[:health_bar_padding] + 1, health_color)
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
        GOOD_HEALTH_COLOR
      elsif health_percent > 0.3
        MEDIUM_HEALTH_COLOR
      else
        BAD_HEALTH_COLOR
      end
    end

    def health_percent
      @health_percent ||= @health_points.to_f / @initial_health_points.to_f
    end
end