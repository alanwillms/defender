describe Defense do
  building_settings = {
    damage: 10,
    range: 4,
    max_range: 4,
    speed: 4,
    bullet_speed: 4,
    life: 4,
    shield: 4,
    cost: 4
  }

  let :defense do
    Defense.new(instance_double("Map"), 0, 0, :cannon)
  end

  let :monster do
    monster = double('Monster', health_points: 5)
    allow(monster).to receive(:health_points=)
    monster
  end

  before :each do
    allow(Game).to receive(:config).and_return({buildings: {cannon: building_settings}})
    allow(MapHelper).to receive(:tile_size).and_return(32)
    allow(MapHelper).to receive(:fix_z_for_row).and_return(0)
    allow(MapHelper).to receive(:get_x_for_column).and_return(0)
    allow(MapHelper).to receive(:get_y_for_row).and_return(0)
  end

  context "monster_at_range?" do
    it "returns true if its range >= distance" do
      # x = 16 and y = 16 is the center of the first row and first column (tile size = 32)
      allow(monster).to receive(:center).and_return([16, 16])
      expect(defense.monster_at_range?(monster)).to be true
    end

    it "returns true if its range >= distance" do
      allow(monster).to receive(:center).and_return([9_999, 9_999])
      expect(defense.monster_at_range?(monster)).to be false
    end
  end

  context "cooled_down?" do
    it "returns true if never shoot" do
      expect(defense.cooled_down?).to be true
    end

    it "returns true if last shoot has been enough time before" do
      defense.shoot! monster
      allow(Gosu).to receive(:milliseconds).and_return(Defense::COOL_DOWN_MILISECONDS * 5)
      expect(defense.cooled_down?).to be true
    end

    it "returns false if last shoot was too recent" do
      defense.shoot! monster
      expect(defense.cooled_down?).to be false
    end
  end

  context "shoot!" do
    context "monster has more health points than damage suffered" do
      it "reduces monster health_points" do
        allow(monster).to receive(:health_points).and_return(30)
        expect(monster).to receive(:health_points=).with(30 - building_settings[:damage])
        defense.shoot! monster
      end
    end

    context "monster has more health points than damage suffered" do
      it "reduces monster health_points" do
        allow(monster).to receive(:health_points).and_return(1)
        expect(monster).to receive(:health_points=).with(0)
        defense.shoot! monster
      end
    end
  end
end