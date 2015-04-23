describe SpriteHelper do
  let :fake_font_class do
    Class.new do
      def initialize(window, source, tileable = false)
      end

      def self.load_tiles(window, source, width, height, tileable = false)
      end
    end
  end

  let :fake_image_class do
    Class.new do
      def initialize(gosu_image)
      end

      def self.load_tiles(window, source, width, height, tileable = false)
      end
    end
  end

  before :each do
    stub_const("Image", fake_image_class)
    stub_const("Gosu::Font", fake_font_class)
    Game.config[:fonts][:valid] = "path/to/image"
  end

  context ".image" do
    it "returns image based on identifier" do
      expect(SpriteHelper.image(:floor)).to be_a(Image)
    end
  end

  context ".font" do
    it "returns font based on identifier" do
      expect(SpriteHelper.font(:valid)).to be_a(Gosu::Font)
    end

    it "returns default font if invalid identifier" do
      expect(SpriteHelper.font(:in_valid)).to be_a(Gosu::Font)
    end
  end

  context ".tiles" do
    it "returns images list based on identifier" do
      expect(Image).to receive(:load_tiles).once
      SpriteHelper.tiles(:sea)
    end
  end
end