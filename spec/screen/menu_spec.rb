describe Menu do
  let :map do
    instance_double("Map", health_points: 100, buildings: [], monsters: [])
  end

  let :game_screen do
    game_screen = instance_double("GameScreen")
    allow(game_screen).to receive(:money)
    allow(game_screen).to receive(:map).and_return(map)
    game_screen
  end

  let :menu do
    Menu.new(game_screen, 64, 200, 0, 0)
  end

  let :font do
    font = instance_double("Gosu::Font")
    allow(font).to receive(:draw)
    font
  end

  before :each do
    allow(MapHelper).to receive(:screen_padding).and_return(0)
    allow(MapHelper).to receive(:tile_size).and_return(32)
    allow(SpriteHelper).to receive(:image).and_return(instance_double("Gosu::Image"))
    allow(SpriteHelper).to receive(:font).and_return(font)
  end

  context "#add_item" do
    it "adds buildings to the menu" do
      menu.add_item :building_1, -> {}
      menu.add_item :building_2, -> {}
      menu.add_item :building_3, -> {}
      expect(menu.items.size).to eq(3)
    end
  end

  context "#select_item" do
    it "marks item as selected" do
      menu.add_item :building_1, -> {}
      menu.add_item :building_2, -> {}
      menu.add_item :building_3, -> {}
      menu.select_item(menu.items.last)
      expect(menu.selected_item).to be(menu.items.last)
      expect(menu.items.last.selected).to be true
    end
  end

  context "#update" do
    it "updates each item" do
      expect_any_instance_of(MenuItem).to receive(:update)
      menu.add_item :building_1, -> {}
      menu.update
    end
  end

  context "#clicked" do
    it "select clicked item" do
      expect_any_instance_of(MenuItem).to receive(:clicked).and_return(true)
      menu.add_item :building_1, -> {}
      menu.clicked
    end
  end

  context "#draw" do
    it "draws each item" do
      expect_any_instance_of(MenuItem).to receive(:draw)
      menu.add_item :building_1, -> {}
      menu.draw
    end
  end
end