require 'pathname'

module Helper
  module Fixture
    def fixture_dir
      test_dir = Pathname(File.expand_path("../..", __FILE__))
      test_dir.join("fixtures")
    end

    def fixture_path(*components)
      fixture_dir.join(*components)
    end
  end
end
