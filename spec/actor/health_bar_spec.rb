describe HealthBar do

  let :game do
    mock = instance_double('Game')
    allow(mock).to receive(:draw_quad)
    mock
  end

  before :each do
    allow(Game).to receive(:current_window).and_return(game)
    allow(MapHelper).to receive(:tile_size).and_return(32)
  end

  context '#draw' do
    it "doesn't draw if health is full" do
      health_bar = HealthBar.new(100, 100, 0, 0)
      expect(game).not_to receive(:draw_quad)
      health_bar.draw
    end

    it "draws bar if health is not full" do
      health_bar = HealthBar.new(1, 100, 0, 0)
      expect(game).to receive(:draw_quad)
      expect(game).to receive(:draw_quad)
      health_bar.draw
    end

    context "get the color based on health percent" do
      it "uses green for good health" do
        health_bar = HealthBar.new(71, 100, 0, 0)
        expect(health_bar).to receive(:draw_bar).with(anything, anything, anything, anything, anything, anything, HealthBar::BACKGROUND_COLOR)
        expect(health_bar).to receive(:draw_bar).with(anything, anything, anything, anything, anything, anything, HealthBar::GOOD_HEALTH_COLOR)
        health_bar.draw
      end

      it "uses yellow for medium health" do
        health_bar = HealthBar.new(31, 100, 0, 0)
        expect(health_bar).to receive(:draw_bar).with(anything, anything, anything, anything, anything, anything, HealthBar::BACKGROUND_COLOR)
        expect(health_bar).to receive(:draw_bar).with(anything, anything, anything, anything, anything, anything, HealthBar::MEDIUM_HEALTH_COLOR)
        health_bar.draw
      end

      it "uses red for bad health" do
        health_bar = HealthBar.new(1, 100, 0, 0)
        expect(health_bar).to receive(:draw_bar).with(anything, anything, anything, anything, anything, anything, HealthBar::BACKGROUND_COLOR)
        expect(health_bar).to receive(:draw_bar).with(anything, anything, anything, anything, anything, anything, HealthBar::BAD_HEALTH_COLOR)
        health_bar.draw
      end
    end
  end
end