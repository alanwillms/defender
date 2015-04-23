describe Building do
  let :image do
    image = instance_double("Image")
    allow(image).to receive(:resized_width).and_return(32)
    allow(image).to receive(:resized_height).and_return(32)
    image
  end

  let :building do
    Building.new(Cell.new(instance_double("Map"), 0, 0), :cannon)
  end

  before :each do
    allow(SpriteHelper).to receive(:image).and_return(image)
    allow(MapHelper).to receive(:tile_size).and_return(32)
    allow(MapHelper).to receive(:fix_z_for_row).and_return(0)
    allow(MapHelper).to receive(:get_x_for_column).and_return(0)
    allow(MapHelper).to receive(:get_y_for_row).and_return(0)
  end

  context "#initialize" do
    it "sets attributes based on its type" do
      expect(building.cost).to be(Game.config[:buildings][:cannon][:cost])
    end

    it "detects type if not informed based on subclass name" do
      defending_city = DefendingCity.new(Cell.new(instance_double("Map"), 0, 0))
      expect(defending_city.type).to be(:defending_city)
    end
  end

  context "#draw" do
    it "renders the image" do
      expect(image).to receive(:draw_resized).with(0, 0, 0)
      building.draw
    end

    it "starts lower if image is shorter than tile" do
      allow(MapHelper).to receive(:tile_size).and_return(32)
      allow(image).to receive(:resized_height).and_return(12)
      expect(image).to receive(:draw_resized).with(0, 20, 0)
      building.draw
    end

    it "starts higher if image is taller than tile" do
      allow(MapHelper).to receive(:tile_size).and_return(32)
      allow(image).to receive(:resized_height).and_return(48)
      expect(image).to receive(:draw_resized).with(0, -16, 0)
      building.draw
    end
  end
end