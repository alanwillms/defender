class MapHelper
  @@tile_size = nil

  def self.get_x_for_column(column)
    column * tile_size
  end

  def self.get_y_for_row(row)
    row * tile_size
  end

  def self.get_column_for_x(x)
    x / tile_size
  end

  def self.get_row_for_y(y)
    y / tile_size
  end

  def self.tile_size
    @@tile_size ||= SpriteHelper.image(:floor).width
  end
end