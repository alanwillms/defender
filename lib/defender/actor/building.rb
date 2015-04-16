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
    image = SpriteHelper.image(@type)
    fixed_y = y
    fixed_z = MapHelper.fix_z_for_row(z, @row)
    if image.height > MapHelper.tile_size
      fixed_y = y - (image.height - MapHelper.tile_size)
    elsif image.height < MapHelper.tile_size
      fixed_y = y + (MapHelper.tile_size - image.height)
    end
    image.draw(x, fixed_y, fixed_z)
  end

  def self.types
    Game.config[:buildings]
  end

  private

    def setup_attributes
      attributes = self.class.types[@type]
      @attack = attributes[:damage]
      @range = attributes[:range]
      @max_range = attributes[:max_range]
      @speed = attributes[:speed]
      @health_points = @initial_health_points = attributes[:life]
      @shield = attributes[:shield]
      @cost = attributes[:cost]
    end

    def x
      MapHelper.get_x_for_column(@column)
    end

    def y
      MapHelper.get_y_for_row(@row)
    end

    def z
      ZOrder::Entity
    end
end