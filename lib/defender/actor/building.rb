class Building

  attr_reader :row, :column, :cost, :type

  def initialize(map, row, column, type)
    @map = map
    @row = row
    @column = column
    @type = type
    setup_attributes
  end

  def draw
    image.draw(x, y, z)
  end

  private

    def setup_attributes
      attributes = Game.config[:buildings][@type]
      @attack = attributes[:damage]
      @range = attributes[:range]
      @max_range = attributes[:max_range]
      @speed = attributes[:speed]
      @health_points = @initial_health_points = attributes[:life]
      @shield = attributes[:shield]
      @cost = attributes[:cost]
    end

    def image
      @image ||= SpriteHelper.image(@type)
    end

    def x
      MapHelper.get_x_for_column(@column)
    end

    def y
      value = MapHelper.get_y_for_row(@row)
      if image.height > MapHelper.tile_size
        value - (image.height - MapHelper.tile_size)
      elsif image.height < MapHelper.tile_size
        value + (MapHelper.tile_size - image.height)
      else
        value
      end
    end

    def z
      MapHelper.fix_z_for_row(ZOrder::Entity, @row)
    end
end