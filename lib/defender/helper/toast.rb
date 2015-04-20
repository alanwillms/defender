class ToastHelper
  MESSAGE_DURATION = 3000

  @@messages = []

  def self.add_message(message, type = :info)
    @@messages << ToastMessage.new(message, type)
  end

  def self.update
    @@messages.each do |message|
      if message.expires_at < Gosu::milliseconds
        @@messages.delete message
      end
    end
  end

  def self.draw
    x = Game.current_window.width / 2
    y = Game.current_window.height / 2
    z = ZOrder::UI
    font = SpriteHelper.font(:toast, font_height)
    toast = @@messages.last
    unless toast
      return
    end
    # @@messages.each do |toast|
      font.draw_rel(toast.message, x - 2, y - 2, z, 0.5, 0.5, 1, 1, 0xff000000)
      font.draw_rel(toast.message, x, y, z, 0.5, 0.5, 1, 1, toast.color)
    # end
  end

  private

    def self.font_height
      (MapHelper.tile_size * 1.2).to_i
    end
end

class ToastMessage
  attr_reader :message, :type, :expires_at

  def initialize(message, type)
    @message = message
    @type = type
    @expires_at = Gosu::milliseconds + ToastHelper::MESSAGE_DURATION
  end

  def color
    0xffffffff
  end
end