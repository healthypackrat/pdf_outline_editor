# frozen_string_literal: true

module AssetHelpers
  def path_for_asset(basename)
    File.join(__dir__, '../assets', basename)
  end
end

RSpec.configure do |config|
  config.include AssetHelpers
end
