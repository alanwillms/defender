class GameOverScreen < BaseScreen
  def initialize
    AudioHelper.play(:game_over, false)
  end

  def draw
    SpriteHelper.font.draw("GAME OVER!", 64, 64, ZOrder::UI, 3, 3)
  end
end