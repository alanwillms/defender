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
end