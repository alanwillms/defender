class Building
  attr_reader :row, :column

  def initialize(map, row, column)
    @map = map
    @row = row
    @column = column
    @map.build_at!(self, @row, @column)
  end

  def draw
    x = MapHelper.get_x_for_column(@column)
    y = MapHelper.get_y_for_row(@row)
    z = ZOrder::Building
    SpriteHelper.image(sprite_name.to_sym).draw(x, y, z)
  end

  private
    def sprite_name
      self.class.name.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
    end
end