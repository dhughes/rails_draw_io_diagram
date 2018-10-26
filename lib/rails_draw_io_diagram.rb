# frozen_string_literal: true

require "rails_draw_io_diagram/version"

$LOAD_PATH.unshift(File.dirname(__FILE__))

Dir[File.expand_path('rails_draw_io_diagram/*.rb', __dir__)].each { |f| require f }
Dir[File.expand_path('rails_draw_io_diagram/**/*.rb', __dir__)].each { |f| require f }

module RailsDrawIoDiagram
end
