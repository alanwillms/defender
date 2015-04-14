class ToastHelper
  MESSAGE_DURATION = 3000

  @@toasts = []

  def self.add_message(message, type = :info)
    @@toasts << ToastMessage.new(message, type)
  end

  def self.update
    @@toasts.each do |message|
      if message.expires_at < Gosu::milliseconds
        @@toasts.delete message
      end
    end
  end

  def self.draw
    x = 256
    y = 256
    @@toasts.each do |toast|
      SpriteHelper.font.draw(toast.message, x, y, ZOrder::UI, 1, 1, toast.color)
    end
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
    0xffff0000
  end
end