describe GameOverScreen do
  let :font do
    instance_double("Gosu::Font")
  end

  before :each do
    allow(AudioHelper).to receive(:play_song).and_return(nil)
    allow(SpriteHelper).to receive(:font).and_return(font)
  end

  it "plays song on initialize" do
    expect(AudioHelper).to receive(:play_song).once
    GameOverScreen.new
  end

  it "draws a message" do
    expect(font).to receive(:draw).once
    GameOverScreen.new.draw
  end
end