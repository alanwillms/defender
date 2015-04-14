class Menu
  attr_reader :selected_item

  def initialize(screen, width, height, x, y)
    @screen = screen
    @x = @items_x = (x + MapHelper.screen_padding)
    @y = @items_y = y
    @width = width
    @height = height
    @items = []
    @items_x = @x
    @items_y = @y + (5 * MapHelper.tile_size)
    @texts_x = @x
    @texts_y = @y
    @selected_item = nil
  end

  def add_item(defense_type, callback)
    item = MenuItem.new(defense_type, @items_x, @items_y, ZOrder::UI, callback)
    @items << item
    increase_items_x
    if @selected_item.nil?
      select_item item
    end
  end

  def select_item(item)
    @items.each do |other_item|
      other_item.selected = false
    end
    @selected_item = item
    item.selected = true
  end

  def update
    @items.each do |item|
      item.update
    end
  end

  def clicked
    @items.each do |item|
      if item.clicked
        select_item(item)
      end
    end
  end

  def draw
    @texts_y = @y
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
      @items_y += 100
    end

    def increase_items_x
      @items_x += MapHelper.tile_size

      if @items_x > (@x + @width - MapHelper.tile_size - MapHelper.screen_padding)
        @items_x = @x
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

  attr_reader :defense_type, :main_image
  attr_accessor :selected

  def initialize (defense_type, x, y, z, callback)
    @defense_type = defense_type
    @main_image = SpriteHelper.image(defense_type)
    @hover_image = @main_image
    @original_x = @x = x
    @original_y = @y = y
    @z = z
    @callback = callback
    @active_image = @main_image
    @selected = false
  end

  def draw
    if @selected
      color = 0xff4caf50
      Window.current_window.draw_quad(
        @x, @y, color,
        @x + @active_image.width, @y, color,
        @x, @y + @active_image.height, color,
        @x + @active_image.width, @y + @active_image.height, color,
        @z
      )
    end
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
      true
    else
      false
    end
  end
end