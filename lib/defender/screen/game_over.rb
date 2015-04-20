class GameOverScreen < BaseScreen
  def initialize
    AudioHelper.play_song :game_over
  end

  def draw
    SpriteHelper.font.draw("GAME OVER!", 64, 64, ZOrder::UI, 3, 3)
  end
end