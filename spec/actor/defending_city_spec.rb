describe DefendingCity do
  let :image do
    image = instance_double("Image")
    allow(image).to receive(:draw_resized)
    allow(image).to receive(:resized_width).and_return(32)
    allow(image).to receive(:resized_height).and_return(32)
    image
  end

  let :defending_city do
    defending_city = DefendingCity.new(Cell.new(instance_double("Map"), 0, 0))
    allow(defending_city).to receive(:image).and_return(image)
    defending_city
  end

  let :monster do
    double('Monster')
  end

  before :each do
    allow(SpriteHelper).to receive(:image).and_return(image)
    allow(MapHelper).to receive(:tile_size).and_return(32)
    allow(MapHelper).to receive(:fix_z_for_row).and_return(0)
    allow(MapHelper).to receive(:get_x_for_column).and_return(0)
    allow(MapHelper).to receive(:get_y_for_row).and_return(0)
  end

  context "#monster_arrived?" do
    it "returns true if a monster is at same row and column" do
      allow(monster).to receive(:current_row).and_return(0)
      allow(monster).to receive(:current_column).and_return(0)
      expect(defending_city.monster_arrived?(monster)).to be true
    end

    it "returns false if a monster is not at same row or column" do
      allow(monster).to receive(:current_row).and_return(123)
      allow(monster).to receive(:current_column).and_return(456)
      expect(defending_city.monster_arrived?(monster)).to be false
    end
  end

  context "#draw" do

    it "calls parent method" do
      expect(image).to receive(:draw_resized)
      defending_city.draw
    end

    it "renders a health bar" do
      health_bar = double('health_bar')
      allow(HealthBar).to receive(:new).and_return(health_bar)
      expect(health_bar).to receive(:draw)
      defending_city.draw
    end
  end
end