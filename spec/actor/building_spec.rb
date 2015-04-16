describe Building do
  building_settings = {
    damage: 1,
    range: 2,
    max_range: 3,
    speed: 4,
    bullet_speed: 5,
    life: 6,
    shield: 7,
    cost: 8
  }

  let :image do
    image = instance_double("Gosu::Image")
    allow(image).to receive(:width).and_return(32)
    allow(image).to receive(:height).and_return(32)
    image
  end

  let :building do
    Building.new(instance_double("Map"), 0, 0, :example)
  end

  before :each do
    allow(Game).to receive(:config).and_return({buildings: {example: building_settings}})
    allow(SpriteHelper).to receive(:image).and_return(image)
    allow(MapHelper).to receive(:tile_size).and_return(32)
    allow(MapHelper).to receive(:fix_z_for_row).and_return(0)
    allow(MapHelper).to receive(:get_x_for_column).and_return(0)
    allow(MapHelper).to receive(:get_y_for_row).and_return(0)
  end

  context "#initialize" do
    it "sets attributes based on its type" do
      expect(building.row).to be(0)
      expect(building.column).to be(0)
      expect(building.cost).to be(8)
      expect(building.type).to be(:example)
    end
  end

  context "#draw" do

    it "renders the image" do
      expect(image).to receive(:draw).with(0, 0, 0)
      building.draw
    end

    it "starts lower if image is shorter than tile" do
      allow(MapHelper).to receive(:tile_size).and_return(32)
      allow(image).to receive(:height).and_return(12)
      expect(image).to receive(:draw).with(0, 20, 0)
      building.draw
    end

    it "starts higher if image is taller than tile" do
      allow(MapHelper).to receive(:tile_size).and_return(32)
      allow(image).to receive(:height).and_return(48)
      expect(image).to receive(:draw).with(0, -16, 0)
      building.draw
    end
  end
end