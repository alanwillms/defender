describe Game do
  config = {environment: :test, height: 32, width: 32, full_screen: false, caption: ""}

  let(:game) do
    game = Game.new(config)
    game.current_screen = instance_double("GameScreen")
    game
  end

  it "shares its config through a \#config" do
    expect(game.class.config).to be config
  end

  it "saves itself as a singleton" do
    expect(game.class.current_window).to be game
  end

  it "displays the cursor" do
    expect(game.needs_cursor?).to be true
  end

  it "draws screen on draw" do
    expect(game.current_screen).to receive(:draw)
    game.draw
  end

  it "updates screen on update" do
    expect(game.current_screen).to receive(:update)
    game.update
  end

  context "when user calls button_down" do
    it "closes if the id is ESC" do
      expect(game).to receive(:close)
      game.button_down Gosu::KbEscape
    end

    it "calls screen button_down if the id is not ESC" do
      expect(game.current_screen).to receive(:button_down).with(Gosu::KbUp)
      game.button_down Gosu::KbUp
    end
  end
end