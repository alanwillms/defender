describe SpriteHelper do
  let :fake_image_class do
    Class.new do
      def initialize(window, source, tileable = false)
      end

      def self.load_tiles(window, source, width, height, tileable = false)
      end
    end
  end

  before :each do
    stub_const("Gosu::Image", fake_image_class)
    stub_const("Gosu::Font", fake_image_class)
    allow(Game).to receive(:config).and_return({
      images: {valid: "path/to/image"},
      fonts: {valid: "path/to/font"},
      sprites: {valid: "path/to/sprite"}
    })
  end

  context ".image" do
    it "returns image based on identifier" do
      expect(SpriteHelper.image(:valid)).to be_a(Gosu::Image)
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
      expect(Gosu::Image).to receive(:load_tiles).once
      SpriteHelper.tiles(:valid)
    end
  end
end