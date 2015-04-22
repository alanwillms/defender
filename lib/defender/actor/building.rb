class Building
  attr_reader :cell, :cost, :type

  def initialize(cell, type = nil)
    @cell = cell
    @type = type || guess_type
    @attack = attributes[:damage]
    @range = attributes[:range]
    @max_range = attributes[:max_range]
    @speed = attributes[:speed]
    @health_points = @initial_health_points = attributes[:life]
    @shield = attributes[:shield]
    @cost = attributes[:cost]
  end

  def draw
    image.draw(x, y, z)
  end

  private

    def image
      @image ||= SpriteHelper.image(@type)
    end

    def x
      cell.point.x
    end

    def y
      value = cell.point.y
      if image.height > MapHelper.tile_size
        value - (image.height - MapHelper.tile_size)
      elsif image.height < MapHelper.tile_size
        value + (MapHelper.tile_size - image.height)
      else
        value
      end
    end

    def z
      MapHelper.fix_z_for_row(ZOrder::Entity, cell.row)
    end

    def guess_type
      self.class.name.underscore.to_sym
    end

    def attributes
      Game.config[:buildings][@type]
    end
end