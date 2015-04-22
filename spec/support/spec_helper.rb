# Must load Simplecov before everything else, otherwise won't cover anything!
require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../../lib")
require 'defender'

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    # Disable Rspec2 "should"
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before :all do
    # Load game shared configs
    configs_dir = "#{File.dirname(__FILE__)}/../../config"

    game_config = YAML.load_file("#{configs_dir}/environment.yml")
    game_config[:monsters] = YAML.load_file("#{configs_dir}/monsters.yml")
    game_config[:buildings] = YAML.load_file("#{configs_dir}/buildings.yml")
    game_config[:waves] = YAML.load_file("#{configs_dir}/waves.yml")
    game_config[:sounds] = YAML.load_file("#{configs_dir}/sounds.yml")
    game_config[:songs] = YAML.load_file("#{configs_dir}/songs.yml")
    game_config[:sprites] = YAML.load_file("#{configs_dir}/sprites.yml")
    game_config[:images] = YAML.load_file("#{configs_dir}/images.yml")
    game_config[:fonts] = YAML.load_file("#{configs_dir}/fonts.yml")

    # Overwrite a few settings
    game_config[:environment] = :test
    game_config[:width] = 1024
    game_config[:height] = 768

    # Initialize
    Game.new(game_config)
  end
end