class SpriteHelper
  @@images = {}
  @@fonts = {}
  @@tilesets = {}

  def self.image(identifier)
    @@images[identifier] ||= Image.new(Gosu::Image.new(
      Game.current_window,
      Game.config[:images][identifier],
      true
    ))
  end

  def self.font(identifier = :default, height = 20)
    source = Game.config[:fonts][identifier]
    unless source
      source = Gosu::default_font_name
    end
    identifier = (identifier.to_s + '_' + height.to_s).to_sym
    @@fonts[identifier] ||= Gosu::Font.new(Game.current_window, source, height)
  end

  def self.tiles(identifier)
    @@tilesets[identifier] ||= Image::load_tiles(
      Game.current_window,
      Game.config[:sprites][identifier][:source],
      Game.config[:sprites][identifier][:frame_width],
      Game.config[:sprites][identifier][:frame_height],
      tileable = true
    )
  end
end