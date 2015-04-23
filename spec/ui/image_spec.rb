describe Image do
  let :gosu_image do
    gosu_image = instance_double("Gosu::Image")
    allow(gosu_image).to receive(:width).and_return(Game.config[:tile_size] * 2)
    allow(gosu_image).to receive(:height).and_return(Game.config[:tile_size] * 4)
    allow(Gosu::Image).to receive(:load_tiles).and_return([gosu_image])
    gosu_image
  end

  let :subject do
    Image.new(gosu_image)
  end

  context "#draw_resized" do
    it "draws with new factor_x and factor_y" do
      factor_x = 0.5
      factor_y = 0.5
      expect(gosu_image).to receive(:draw).with(0, 0, 0, factor_x, factor_y, any_args)
      subject.draw_resized(0, 0, 0)
    end
  end

  context "#draw_rot_resized" do
    it "draws rotated with new factor_x and factor_y" do
      factor_x = 0.5
      factor_y = 0.5
      expect(gosu_image).to receive(:draw_rot).with(0, 0, 0, 0, 0.5, 0.5, factor_x, factor_y, any_args)
      subject.draw_rot_resized(0, 0, 0, 0)
    end
  end

  context "#resized_height" do
    it "returns height at the proportion of #resized_width" do
      expect(subject.resized_height).to eq(Game.config[:tile_size] * 2)
    end
  end

  context "#resized_width" do
    it "returns tile size" do
      expect(subject.resized_width).to eq(Game.config[:tile_size])
    end
  end

  context ".load_tiles" do
    it "returns an Array of Image instead of Gosu::Image" do
      identifier = :sea
      tiles = Image.load_tiles(
        Game.current_window,
        Game.config[:sprites][identifier][:source],
        Game.config[:sprites][identifier][:frame_width],
        Game.config[:sprites][identifier][:frame_height],
        true
      )
      expect(tiles.first).to be_an(Image)
    end
  end
end