class MenuItem
  HOVER_OFFSET = 3

  attr_reader :defense_type, :main_image
  attr_accessor :selected, :active_image

  def initialize(defense_type, x, y, z, callback)
    @defense_type = defense_type
    @main_image = SpriteHelper.image(defense_type)
    @hover_image = @main_image
    @active_image = @main_image
    @x = x
    @y = y
    @z = z
    @callback = callback
    @selected = false
  end

  def draw
    if @selected
      color = 0xff4caf50
      Game.current_window.draw_quad(
        @x - 2, @y - 2, color,
        @x + @active_image.resized_width + 2, @y - 2, color,
        @x - 2, @y + @active_image.resized_height + 2, color,
        @x + @active_image.resized_width + 2, @y + @active_image.resized_height + 2, color,
        @z
      )
    end
    @active_image.draw_resized(@x, @y, @z)
  end

  def update
    if is_mouse_hovering and @hover_image
      @active_image = @hover_image
    else
      @active_image = @main_image
    end
  end

  def clicked
    if is_mouse_hovering then
      @callback.call
      true
    else
      false
    end
  end

  private

    def is_mouse_hovering
      mx = Game.current_window.mouse_x
      my = Game.current_window.mouse_y

      (mx >= @x and my >= @y) and (mx <= @x + @active_image.resized_width) and (my <= @y + @active_image.resized_height)
    end
end