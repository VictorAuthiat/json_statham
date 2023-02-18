# frozen_string_literal: true

require "spec_helper"
require "generator_spec"
require "generators/json_statham/install_generator"

RSpec.describe JsonStatham::InstallGenerator do
  include GeneratorSpec::TestCase

  destination File.expand_path("tmp", __dir__)

  before(:all) do
    prepare_destination
    run_generator
  end

  it "installs Rails initializer" do
    assert_file("config/initializers/json_statham.rb")
  end
end
