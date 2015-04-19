describe AudioHelper do
  let :fake_audio_class do
    Class.new do
      def initialize(window, source)
      end

      def play(repeat = false)
      end
    end
  end

  before :each do
    stub_const("Gosu::Sample", fake_audio_class)
    stub_const("Gosu::Song", fake_audio_class)
    allow_any_instance_of(Gosu::Sample).to receive(:play)
    allow_any_instance_of(Gosu::Song).to receive(:play)
    allow(Game).to receive(:config).and_return({
      sounds: {existant: Tempfile.new.path},
      songs: {existant: Tempfile.new.path}
    })
  end

  context "#play_sound" do
    it "plays sound if exists" do
      expect_any_instance_of(Gosu::Sample).to receive(:play).once
      AudioHelper.play_sound(:existant)
    end

    it "doesn't if doesn't exist" do
      expect_any_instance_of(Gosu::Sample).not_to receive(:play)
      AudioHelper.play_sound(:non_existant)
    end
  end

  context "#play_song" do
    it "plays if exists" do
      expect_any_instance_of(Gosu::Song).to receive(:play).once
      AudioHelper.play_song(:existant)
    end

    it "doesn't play if doesn't exist" do
      expect_any_instance_of(Gosu::Song).not_to receive(:play)
      AudioHelper.play_song(:non_existant)
    end
  end
end