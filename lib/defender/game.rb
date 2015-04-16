class Game < Gosu::Window
  @@current_window = nil
  @@config = {}

  def initialize(config)
    super(config[:width], config[:height], config[:full_screen])
    self.caption = config[:window_title]

    @@current_window = self
    @@config = config
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
    @screen ||= GameScreen.new
  end

  def current_screen=(value)
    @screen = value
  end

  def self.current_window
    @@current_window
  end

  def self.config
    @@config
  end
end