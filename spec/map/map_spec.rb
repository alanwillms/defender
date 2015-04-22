describe Map do
  let :menu do
    menu = instance_double("Menu")
    menu_item = instance_double("MenuItem", defense_type: :cannon)
    allow(menu).to receive(:selected_item).and_return(menu_item)
    menu
  end

  let :game_screen do
    game_screen = instance_double("GameScreen", money: 100)
    allow(game_screen).to receive(:money=)
    allow(game_screen).to receive(:menu).and_return(menu)
    game_screen
  end

  let :map do
    Map.new(game_screen, 1024, 768)
  end

  let :monster do
    instance_double("Monster")
  end

  let :monster_spawner do
    MonsterSpawner.new(Cell.new(map, 0, 0))
  end

  let :defending_city do
    DefendingCity.new(Cell.new(map, map.last_row, map.last_column))
  end

  let :defense do
    defense = Defense.new(Cell.new(map, 0, map.last_column), :cannon)
    defense.instance_variable_set(:@range, 1_000)
    defense.instance_variable_set(:@max_range, 1_000)
    defense
  end

  let :image do
    image = instance_double("Gosu::Image")
    allow(image).to receive(:draw)
    allow(image).to receive(:width).and_return(32)
    allow(image).to receive(:height).and_return(32)
    image
  end

  before :each do
    allow(MapHelper).to receive(:tile_size).and_return(32)
    allow(SpriteHelper).to receive(:image).and_return(image)
    allow(AudioHelper).to receive(:play_sound)
    allow(AudioHelper).to receive(:play_song)
    allow(monster_spawner).to receive(:spawn_wave)

    map.build(defending_city)
    map.build(monster_spawner)
    map.build(defense)
    map.build_random_walls
  end

  context "#maze" do
    it "returns a Maze instance" do
      expect(map.maze).to be_a(Maze)
    end
  end

  context "#unspawn_monster" do
    it "removes a monster from the list" do
      map.monsters << monster
      map.unspawn_monster monster
      expect(map.monsters.size).to be(0)
    end

    it "spawns a new wave if there is no monster left" do
      expect(monster_spawner).to receive(:spawn_wave)
      map.monsters << monster
      map.unspawn_monster monster
    end
  end

  context "#buildings" do
    it "returns all registered buildings" do
      expect(map.buildings).to include(defending_city)
      expect(map.buildings).to include(monster_spawner)
      expect(map.buildings).to include(defense)
    end
  end

  context "#defending_cities" do
    it "returns only DefendingCity instances" do
      expect(map.defending_cities).to include(defending_city)
      expect(map.defending_cities).not_to include(monster_spawner)
      expect(map.defending_cities).not_to include(defense)
    end
  end

  context "#monster_spawners" do
    it "returns only MonsterSpawner instances" do
      expect(map.monster_spawners).to include(monster_spawner)
      expect(map.monster_spawners).not_to include(defending_city)
      expect(map.monster_spawners).not_to include(defense)
    end
  end

  context "#defenses" do
    it "returns only Defense instances" do
      expect(map.defenses).to include(defense)
      expect(map.defenses).not_to include(monster_spawner)
      expect(map.defenses).not_to include(defending_city)
    end
  end

  context "#health_points" do
    it "sums defending cities health points" do
      expect(map.health_points).to eq(defending_city.health_points)
    end
  end

  context "#build_random_walls" do
    it "creates random wall buildings" do
      current_buildings_count = map.buildings.size
      map.build_random_walls
      expect(map.buildings.size).not_to eq(current_buildings_count)
    end
  end

  context "#build" do
    it "add a building to map#buildings" do
      new_wall = Building.new(Cell.new(map, 2, 2), :wall)
      map.build(new_wall)
      expect(map.buildings).to include(new_wall)
    end
  end

  context "#pay" do
    it "decrease amount of money" do
      expect(game_screen).to receive(:money=).with(80)
      map.pay(20)
    end
  end

  context "#has_element_at?" do
    it "returns true if there is an element at the position" do
      expect(map.has_element_at?(Cell.new(map, 0, 0))).to be true
    end

    it "returns false if there is no element at the position" do
      expect(map.has_element_at?(Cell.new(map, 5, 5))).to be false
    end
  end

  context "#draw" do
    it "draws the floor" do
      expect(SpriteHelper).to receive(:image).with(:floor)
      map.draw
    end

    it "draws the buildings" do
      expect(monster_spawner).to receive(:draw)
      expect(defending_city).to receive(:draw)
      map.draw
    end

    it "draws the monsters" do
      map.monsters << monster
      expect(monster).to receive(:draw)
      map.draw
    end
  end

  context "#update" do
    before :each do
      map.monsters << monster
      allow(monster).to receive(:find_target)
      allow(monster).to receive(:move)
      allow(monster).to receive(:current_row).and_return(defending_city.cell.row)
      allow(monster).to receive(:current_column).and_return(defending_city.cell.column)
      allow(monster).to receive(:attack!)
      allow(monster).to receive(:center).and_return([0, 0])
      allow(monster).to receive(:money_loot).and_return(10)
      allow(monster).to receive(:health_points).and_return(0)
      allow(monster).to receive(:health_points=)
    end

    it "moves monsters" do
      expect(monster).to receive(:find_target).at_least(:once)
      expect(monster).to receive(:move).at_least(:once)
      map.update
    end

    context "when monster is attacking" do
      it "monster attack defending city" do
        expect(monster).to receive(:attack!).with(defending_city).at_least(:once)
        map.update
      end

      it "unspawn the monster" do
        expect(map).to receive(:unspawn_monster).with(monster).at_least(:once)
        map.update
      end

      it "plays monster attack sound" do
        expect(AudioHelper).to receive(:play_sound).with(:monster_attack).at_least(:once)
        map.update
      end

      context "when defending city is defeated" do
        it "blocks defending city cell" do
          allow(defending_city).to receive(:health_points).and_return(0)
          expect_any_instance_of(Maze).to receive(:block).with(defending_city.cell)
          map.update
        end
      end
    end

    context "when monster is at the range of a defense" do
      before :each do
        allow(monster).to receive(:health_points=)
      end

      it "makes defense attack monster" do
        expect(defense).to receive(:shoot!).with(monster)
        map.update
      end

      it "plays defense attack sound" do
        expect(AudioHelper).to receive(:play_sound).with(:defense_shot)
        map.update
      end

      context "and monster dies" do
        it "unspawn monster" do
          expect(map).to receive(:unspawn_monster).with(monster).at_least(:once)
          map.update
        end

        it "earns money loot" do
          expect(game_screen).to receive(:money=)
          map.update
        end

        it "plays monster death sound" do
          expect(AudioHelper).to receive(:play_sound).with(:monster_death)
          map.update
        end
      end
    end

    context "when health points are 0" do
      it "shows game over screen" do
        allow(map).to receive(:health_points).and_return(0)
        expect(Game.current_window).to receive(:current_screen=)
        map.update
      end
    end
  end

  context "#clicked" do
    context "clicked outside" do
      it "does nothing" do
        allow(Game.current_window).to receive(:mouse_x).and_return(-1)
        allow(Game.current_window).to receive(:mouse_y).and_return(-1)
        expect(map).not_to receive(:can_pay_for?)
        expect(map).not_to receive(:can_build_at?)
        map.clicked
      end
    end

    context "clicked inside" do
      context "empty cell" do
        before :each do
          allow(Game.current_window).to receive(:mouse_x).and_return(3 * MapHelper.tile_size)
          allow(Game.current_window).to receive(:mouse_y).and_return(3 * MapHelper.tile_size)
        end

        context "user has enough money to build" do
          it "builds the defense" do
            allow(game_screen).to receive(:money).and_return(100_000)
            expect(map).to receive(:build).at_least(:once)
            expect(map).to receive(:pay).at_least(:once)
            expect(AudioHelper).to receive(:play_sound).with(:defense_built)
            map.clicked
          end
        end

        context "user has no money to build" do
          it "alerts user if he has no money to build" do
            allow(game_screen).to receive(:money).and_return(0)
            expect(AudioHelper).to receive(:play_sound).with(:cant_build)
            map.clicked
          end
        end
      end

      context "occupied cell" do
        it "alerts user he can't build at that position" do
          allow(Game.current_window).to receive(:mouse_x).and_return(Game.config[:screen_padding] + 1)
          allow(Game.current_window).to receive(:mouse_y).and_return(Game.config[:screen_padding] + 1)
          expect(AudioHelper).to receive(:play_sound).with(:cant_build)
          map.clicked
        end
      end
    end
  end
end