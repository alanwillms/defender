class SpriteHelper
  @@images = {}
  @@fonts = {}
  @@tilesets = {}

  def self.image(identifier)
    source = nil

    case identifier
      when :defense_button
        source = "media/images/defense.png"
      when :monster_spawner
        source = "media/images/monster_spawner.png"
      when :defending_city
        source = "media/images/defending_city.png"
      when :floor
        source = "media/images/grass.png"
      when :defense
        source = "media/images/defense.png"
    end

    if @@images[source.to_sym].nil?
      @@images[source.to_sym] = Gosu::Image.new(Window.current_window, source, true)
    end
    @@images[source.to_sym]
  end

  def self.font(identifier = :default)
    if @@fonts[identifier].nil?
      @@fonts[identifier] = Gosu::Font.new(Window.current_window, Gosu::default_font_name, 20)
    end
    @@fonts[identifier]
  end

  def self.tiles(identifier)
    source = nil
    tile_width = nil
    tile_height = nil
    tileable = false

    case identifier
      when :monster
        source = "media/images/monster_sprite.png"
        tile_width = 32
        tile_height = 32
    end

    if @@tilesets[source.to_sym].nil?
      @@tilesets[source.to_sym] = Gosu::Image::load_tiles(Window.current_window, source, tile_width, tile_height, tileable)
    end
    @@tilesets[source.to_sym]
  end
end