class GameOverScreen < BaseScreen
  def initialize
    AudioHelper.play_music :game_over
  end

  def draw
    SpriteHelper.font.draw("GAME OVER!", 64, 64, ZOrder::UI, 3, 3)
  end
end