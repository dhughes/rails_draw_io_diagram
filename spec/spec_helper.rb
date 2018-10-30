require "bundler/setup"
require 'pry-byebug'
require 'rails_draw_io_diagram'
require 'mock_rails_app'
require 'samples'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include Samples

  config.before(:each) do
    RailsDrawIoDiagram::ModelRegistry.reset
    RailsDrawIoDiagram::Sequence.reset
  end
end
