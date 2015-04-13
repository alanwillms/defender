class Menu
  def initialize(screen, width, height, x, y)
    @screen = screen
    @padding = MapHelper.tile_size / 2
    @x = @items_x = x
    @y = @items_y = y
    @width = width
    @height = height
    @items = []
    @items_x = @x + @padding
    @items_y = @y + @padding + (5 * MapHelper.tile_size)
    @texts_x = @x + @padding
    @texts_y = @y + @padding
  end

  def add_item(image_identifier, callback)
    item = MenuItem.new(image_identifier, @items_x, @items_y, ZOrder::UI, callback)
    @items << item
    increase_items_x
  end

  def update
    @items.each do |item|
      item.update
    end
  end

  def clicked
    @items.each do |item|
      item.clicked
    end
  end

  def draw
    @texts_y = @y + @padding
    write "Defender"
    write "Money = #{@screen.money}"
    write "HP = #{@screen.map.health_points}"
    write "Buildings = #{@screen.map.buildings_count}"
    write "Monsters = #{@screen.map.monsters.size}"

    @items.each do |item|
      item.draw
    end
  end

  private
    def increase_items_y
      @items_y += MapHelper.tile_size
    end

    def increase_items_x
      @items_x += MapHelper.tile_size

      if @items_x > (@x + @width - MapHelper.tile_size - @padding)
        @items_x = @x + @padding
        increase_items_y
      end
    end

    def write(value)
      SpriteHelper.font.draw(value, @texts_x, @texts_y, ZOrder::UI)
      @texts_y += MapHelper.tile_size
    end
end

class MenuItem
  HOVER_OFFSET = 3
  def initialize (identifier, x, y, z, callback)
    @main_image = SpriteHelper.image(identifier)
    @hover_image = @main_image
    @original_x = @x = x
    @original_y = @y = y
    @z = z
    @callback = callback
    @active_image = @main_image
  end

  def draw
    @active_image.draw(@x, @y, @z)
  end

  def update
    if is_mouse_hovering then
      if !@hover_image.nil? then
        @active_image = @hover_image
      end

      @x = @original_x + HOVER_OFFSET
      @y = @original_y + HOVER_OFFSET
    else
      @active_image = @main_image
      @x = @original_x
      @y = @original_y
    end
  end

  def is_mouse_hovering
    mx = Window.current_window.mouse_x
    my = Window.current_window.mouse_y

    (mx >= @x and my >= @y) and (mx <= @x + @active_image.width) and (my <= @y + @active_image.height)
  end

  def clicked
    if is_mouse_hovering then
      @callback.call
    end
  end
end