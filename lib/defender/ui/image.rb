class Image < SimpleDelegator
  def draw_resized(x, y, z, color = 0xffffffff, mode = :default)
    draw(x, y, z, factor_x, factor_y, color, mode)
  end

  def draw_rot_resized(x, y, z, angle, center_x = 0.5, center_y = 0.5, color = 0xffffffff, mode = :default)
    draw_rot(x, y, z, angle, center_x, center_y, factor_x, factor_y, color, mode)
  end

  def resized_height
    height * factor_y
  end

  def resized_width
    Game.config[:tile_size]
  end

  def self.load_tiles(window, source, tile_width, tile_height, tileable)
    gosu_images = Gosu::Image.load_tiles(window, source, tile_width, tile_height, tileable)
    images = []
    gosu_images.each do |gosu_image|
      images << Image.new(gosu_image)
    end
    images
  end

  private
    def factor_x
      Game.config[:tile_size].to_f / width.to_f
    end

    def factor_y
      factor_x
    end
end