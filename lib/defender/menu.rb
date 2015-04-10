module Defender
  class Menu
    def initialize(window, width, height, x, y)
      @window = window
      @x = x
      @y = y
      @width = width
      @height = height
      @defense_button = Gosu::Image.new(window, "media/images/defense.png", true)
      @font = Gosu::Font.new(window, Gosu::default_font_name, 20)
    end

    def draw
      @font.draw("Defender", @x + 32, @y + 32, ZOrder::UI)
      @font.draw("HP = #{@window.health_points}", @x + 32, @y + (32 * 2), ZOrder::UI)
      @defense_button.draw(@x + 32, @y + (3 * 32), ZOrder::UI)
    end
  end
end