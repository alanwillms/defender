class HealthBarHelper
  def self.draw(health_points, initial_health_points, x, y)
    # if health_points == initial_health_points
    #   return
    # end
    tile_size = MapHelper.tile_size
    width = tile_size
    padding = 2
    height = 8
    color = get_color(health_points, initial_health_points)
    x1 = x
    y1 = y
    x4 = x + width
    y4 = y + height

    if padding < 1
      padding = 1
    end

    draw_bar(x1, y1, x4, y4, ZOrder::HealthBarBg, padding, 0xff000000)

    percent = health_percent(health_points, initial_health_points)

    x4 = x + (health_percent(health_points, initial_health_points) * width).to_i

    draw_bar(x1, y1, x4, y4, ZOrder::HealthBar, padding + 1, color)
  end

  private
    def self.draw_bar(x1, y1, x4, y4, z, padding, color)
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
      Window.current_window.draw_quad(x1, y1, color, x2, y2, color, x3, y3, color, x4, y4, color, z)
    end

    def self.get_color(health_points, initial_health_points)
      percent = health_percent(health_points, initial_health_points)
      if percent > 0.7
        return 0xff4caf50
      elsif percent > 0.3
        return 0xffffeb3b
      else
        return 0xfff44336
      end
    end

    def self.health_percent(health_points, initial_health_points)
      health_points.to_f / initial_health_points.to_f
    end
end