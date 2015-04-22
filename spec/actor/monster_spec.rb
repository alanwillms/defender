describe Monster do
  let :image do
    image = instance_double("Gosu::Image")
    allow(image).to receive(:width).and_return(32)
    allow(image).to receive(:height).and_return(32)
    image
  end

  let :map do
    Game.current_window.current_screen.map
  end

  let :monster do
    map.monsters.first
  end

  let :target do
    double('Building')
  end

  before :each do
    allow(MapHelper).to receive(:tile_size).and_return(32)
    allow(MapHelper).to receive(:screen_padding).and_return(0)
    tileset = []
    (Monster::SPRITE_FRAMES_COUNT * 4).times { tileset << image }
    allow(SpriteHelper).to receive(:tiles).and_return(tileset)
  end

  context "#warp" do
    it "changes monster row, column, x and y" do
      monster.warp(Cell.new(map, 1, 1))
      expect(monster.x).to eq(32)
      expect(monster.y).to eq(32)
      expect(monster.current_row).to eq(1)
      expect(monster.current_column).to eq(1)
    end
  end

  context "#attack!" do
    context "target has more health points than damage suffered" do
      it "reduces target health_points" do
        allow(target).to receive(:health_points).and_return(30)
        expect(target).to receive(:health_points=).with(30 - Game.config[:monsters][:weak_1][:damage])
        monster.attack! target
      end
    end

    context "target has more health points than damage suffered" do
      it "zero target health_points" do
        allow(target).to receive(:health_points).and_return(1)
        expect(target).to receive(:health_points=).with(0)
        monster.attack! target
      end
    end
  end

  context "#find_target" do
    before :each do
      # Remove all walls
      buildings = map.instance_variable_get(:@buildings_map)
      map.instance_variable_set(:@maze, nil)
      map.buildings.each do |building|
        if building.type == :wall
          buildings[building.cell.row][building.cell.column] = nil
        end
      end

      monster.warp(Cell.new(map, 1, 1))
    end

    it "sets target x and y positions" do
      monster.find_target
      expect(monster.target_x).to be(MapHelper.tile_size)
      expect(monster.target_y).to be(0)
    end

    it "turn up if y decreased" do
      monster.instance_variable_set(:@target_x, monster.x)
      monster.instance_variable_set(:@target_y, monster.y - 1)
      monster.send(:set_face)
      expect(monster.facing).to be(Monster::SPRITE_UP_POSITION)
    end

    it "turn down if y increased" do
      monster.instance_variable_set(:@target_x, monster.x)
      monster.instance_variable_set(:@target_y, monster.y + 1)
      monster.send(:set_face)
      expect(monster.facing).to be(Monster::SPRITE_DOWN_POSITION)
    end

    it "turn left if x decreased" do
      monster.instance_variable_set(:@target_x, monster.x - 1)
      monster.instance_variable_set(:@target_y, monster.y)
      monster.send(:set_face)
      expect(monster.facing).to be(Monster::SPRITE_LEFT_POSITION)
    end

    it "turn right if x increased" do
      monster.instance_variable_set(:@target_x, monster.x + 1)
      monster.instance_variable_set(:@target_y, monster.y)
      monster.send(:set_face)
      expect(monster.facing).to be(Monster::SPRITE_RIGHT_POSITION)
    end
  end

  context "move" do
    context "horizontally" do
      it "decrease x if target at the left" do
        monster.warp(Cell.new(map, 0, 1))
        monster.instance_variable_set(:@target_x, 0)
        monster.instance_variable_set(:@target_y, 0)
        previous_x = monster.x
        monster.move
        expect(monster.x).to be(previous_x - monster.speed)
      end

      it "increase x if target at the right" do
        monster.warp(Cell.new(map, 0, 0))
        monster.instance_variable_set(:@target_x, MapHelper.tile_size)
        monster.instance_variable_set(:@target_y, 0)
        previous_x = monster.x
        monster.move
        expect(monster.x).to be(previous_x + monster.speed)
      end

      it "changes current column if arrived at target" do
        monster.warp(Cell.new(map, 0, 0))
        monster.instance_variable_set(:@target_x, MapHelper.tile_size)
        monster.instance_variable_set(:@target_y, 0)
        monster.speed = MapHelper.tile_size
        monster.move
        expect(monster.current_column).to be(1)
      end
    end

    context "vertically" do
      it "decrease y if target at the top" do
        monster.warp(Cell.new(map, 1, 0))
        monster.instance_variable_set(:@target_x, 0)
        monster.instance_variable_set(:@target_y, 0)
        previous_y = monster.y
        monster.move
        expect(monster.y).to be(previous_y - monster.speed)
      end

      it "increase y if target at the bottom" do
        monster.warp(Cell.new(map, 0, 0))
        monster.instance_variable_set(:@target_x, 0)
        monster.instance_variable_set(:@target_y, MapHelper.tile_size)
        previous_y = monster.y
        monster.move
        expect(monster.y).to be(previous_y + monster.speed)
      end

      it "changes current row if arrived at target" do
        monster.warp(Cell.new(map, 0, 0))
        monster.instance_variable_set(:@target_x, 0)
        monster.instance_variable_set(:@target_y, MapHelper.tile_size)
        monster.speed = MapHelper.tile_size
        monster.move
        expect(monster.current_row).to be(1)
      end
    end
  end

  context "#draw" do
    it "renders the image" do
      expect(image).to receive(:draw)
      monster.draw
    end

    it "renders a health bar" do
      health_bar = double('health_bar')
      allow(HealthBar).to receive(:new).and_return(health_bar)
      expect(image).to receive(:draw)
      expect(health_bar).to receive(:draw)
      monster.draw
    end
  end

  context "#center" do
    it "returns center x,y of the center" do
      allow(MapHelper).to receive(:tile_size).and_return(32)
      monster.warp(Cell.new(map, 0, 0))
      expect(monster.center).to eq([16, 16])
    end
  end
end