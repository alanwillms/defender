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
      when :wall
        source = "media/images/wall.png"
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
    tile_width = 32
    tile_height = 48
    tileable = false

    case identifier
      when :monster_weak_1
        source = "media/images/weak_1.png"
      when :monster_weak_2
        source = "media/images/weak_2.png"
      when :monster_quick_1
        source = "media/images/quick_1.png"
      when :monster_big_hp
        source = "media/images/big_hp.png"
      when :monster_big_shield
        source = "media/images/big_shield.png"
      when :monster_big_damage
        source = "media/images/big_damage.png"
      when :monster_quick_big_hp
        source = "media/images/quick_big_hp.png"
      when :monster_quick_2
        source = "media/images/quick_2.png"
      when :monster_big_hp_shield
        source = "media/images/big_hp_shield.png"
    end

    if @@tilesets[source.to_sym].nil?
      @@tilesets[source.to_sym] = Gosu::Image::load_tiles(Window.current_window, source, tile_width, tile_height, tileable)
    end
    @@tilesets[source.to_sym]
  end
end