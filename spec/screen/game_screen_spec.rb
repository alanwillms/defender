describe GameScreen do
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

  let :font do
    font = instance_double("Gosu::Font")
    allow(font).to receive(:draw)
    allow(font).to receive(:draw_rel)
    font
  end

  let :image do
    image = instance_double("Gosu::Image")
    allow(image).to receive(:draw)
    allow(image).to receive(:width).and_return(32)
    allow(image).to receive(:height).and_return(32)
    image
  end

  let :game do
    game = instance_double("Game", mouse_x: 0, mouse_y: 0)
    allow(game).to receive(:draw_quad)
    allow(game).to receive(:width).and_return(1024)
    allow(game).to receive(:height).and_return(768)
    game
  end

  before :each do
    allow(Game).to receive(:config).and_return({
      tile_size: 32,
      screen_padding: 0,
      width: 1024,
      height: 768,
      buildings: {
        defending_city: building_settings,
        monster_spawner: building_settings,
        wall: building_settings
      },
      waves: {}
    })
    allow(Game).to receive(:current_window).and_return(game)
    allow(SpriteHelper).to receive(:image).and_return(image)
    allow(SpriteHelper).to receive(:font).and_return(font)
    allow(AudioHelper).to receive(:play_song)
    allow(AudioHelper).to receive(:play_sound)
  end

  context "#initialize" do
    it "builds a defending city" do
      expect(subject.map.defending_cities.size).to eq(1)
    end

    it "builds a monster spawner" do
      expect(subject.map.monster_spawners.size).to eq(1)
    end

    it "builds random walls" do
      expect_any_instance_of(Map).to receive(:build_random_walls)
      subject
    end

    it "adds buildings to the menu" do
      expect_any_instance_of(Menu).to receive(:add_item).exactly(3).times
      subject
    end

    it "spawns a wave of monsters" do
      expect_any_instance_of(MonsterSpawner).to receive(:spawn_wave)
      subject
    end

    it "plays a background song" do
      expect(AudioHelper).to receive(:play_song)
      subject
    end
  end

  context "#update" do
    it "updates the menu" do
      expect_any_instance_of(Menu).to receive(:update)
      subject.update
    end

    it "updates the map" do
      expect_any_instance_of(Map).to receive(:update)
      subject.update
    end

    it "updates the toast messages" do
      expect(ToastHelper).to receive(:update)
      subject.update
    end
  end

  context "#draw" do
    it "draws the menu" do
      expect_any_instance_of(Menu).to receive(:draw)
      subject.draw
    end

    it "draws the map" do
      expect_any_instance_of(Map).to receive(:draw)
      subject.draw
    end

    it "draws the toast messages" do
      expect(ToastHelper).to receive(:draw)
      subject.draw
    end
  end

  context "#button_down" do
    context "if it is not a mouse click" do
      it "does nothing" do
        expect_any_instance_of(Menu).not_to receive(:clicked)
        expect_any_instance_of(Map).not_to receive(:clicked)
        subject.button_down(Gosu::KbHome)
      end
    end

    context "if it is a mouse click" do
      it "clicks the menu" do
        expect_any_instance_of(Menu).to receive(:clicked)
        subject.button_down(Gosu::MsLeft)
      end

      it "clicks the map" do
        expect_any_instance_of(Map).to receive(:clicked)
        subject.button_down(Gosu::MsLeft)
      end
    end
  end
end