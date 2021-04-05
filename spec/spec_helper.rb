# frozen_string_literal: true

require "h_builder"

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  config.disable_monkey_patching!
  config.order = :random
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
