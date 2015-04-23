class Animation
  def initialize(identifier)
    @identifier = identifier
  end

  def draw(x, y, z)
    current_image.draw_resized(x, y, z)
  end

  private
    def current_image
      SpriteHelper.tiles(@identifier)[current_frame]
    end

    def current_frame
      (Gosu::milliseconds / 100 % frames_count)
    end

    def frames_count
      Game.config[:sprites][@identifier][:frames]
    end
end