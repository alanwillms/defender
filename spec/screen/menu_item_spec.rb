describe MenuItem do
  let :game do
    game = instance_double("Game")
    allow(game).to receive(:draw_quad)
    allow(game).to receive(:mouse_x).and_return(999_999)
    allow(game).to receive(:mouse_y).and_return(999_999)
    game
  end

  let :menu_item do
    MenuItem.new(:defense_type, 0, 0, 0, -> {})
  end

  let :image do
    image = instance_double("Image")
    allow(image).to receive(:draw_resized)
    allow(image).to receive(:resized_width).and_return(32)
    allow(image).to receive(:resized_height).and_return(32)
    image
  end

  before :each do
    allow(Game).to receive(:current_window).and_return(game)
    allow(SpriteHelper).to receive(:image).and_return(image)
  end

  context "#draw" do
    context "selected item" do
      it "draws highlighted" do
        expect(game).to receive(:draw_quad)
        expect(image).to receive(:draw_resized)
        menu_item.selected = true
        menu_item.draw
      end
    end

    context "unselected item" do
      it "draws without  highlight" do
        expect(game).not_to receive(:draw_quad)
        expect(image).to receive(:draw_resized)
        menu_item.selected = false
        menu_item.draw
      end
    end
  end

  context "#update" do
    context "mouse hovering" do
      it "changes image to hover" do
        allow(Game.current_window).to receive(:mouse_x).and_return(1)
        allow(Game.current_window).to receive(:mouse_y).and_return(1)
        menu_item.update
        expect(menu_item.active_image).not_to be nil # improve
      end
    end

    context "mouse outside" do
      it "changes image to default" do
        menu_item.update
        expect(menu_item.active_image).not_to be nil # improve
      end
    end
  end

  context "#clicked" do
    context "mouse hovering" do
      it "returns true" do
        allow(Game.current_window).to receive(:mouse_x).and_return(1)
        allow(Game.current_window).to receive(:mouse_y).and_return(1)
        expect(menu_item.clicked).to be true
      end
    end

    context "mouse outside" do
      it "returns false" do
        expect(menu_item.clicked).to be false
      end
    end
  end
end