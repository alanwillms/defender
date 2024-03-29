class Menu
  attr_reader :selected_item, :items

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
    write "Buildings = #{@screen.map.buildings.size}"
    write "Monsters = #{@screen.map.monsters.size}"

    @items.each do |item|
      item.draw
    end
  end

  private
    def increase_items_y
      @items_y += 200
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