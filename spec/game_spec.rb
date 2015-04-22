describe Game do
  let(:game) do
    Game.current_window
  end

  it "shares its config through a \#config" do
    expect(Game.config).to be_a(Hash)
  end

  it "saves itself as a singleton" do
    expect(Game.current_window).to be_a(Game)
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