class GameOverScreen
  def initialize
    AudioHelper.play(:game_over, false)
  end

  def update
  end

  def draw
    SpriteHelper.font.draw("GAME OVER!", 64, 64, ZOrder::UI, 3, 3)
  end

  def button_down(id)
  end
end
