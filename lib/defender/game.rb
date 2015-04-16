class Game < Gosu::Window
  @@current_window = nil

  def initialize
    # width, height, fullscreen, update_interval (16.666666)
    super(1900, 1080, false)
    self.caption = 'Defender'

    @@current_window = self
  end

  def update
    current_screen.update
  end

  def draw
    current_screen.draw
  end

  # Show system cursor
  def needs_cursor?
    true
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    else
      current_screen.button_down(id)
    end
  end

  def current_screen
    @current_screen ||= GameScreen.new
  end

  def current_screen=(value)
    @current_screen = value
  end

  def self.current_window
    @@current_window
  end
end