lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "unicode_plot/version"

Gem::Specification.new do |spec|
  spec.name = "unicode_plot"
  version_components = [
    UnicodePlot::Version::MAJOR.to_s,
    UnicodePlot::Version::MINOR.to_s,
    UnicodePlot::Version::MICRO.to_s,
    UnicodePlot::Version::TAG
  ]
  spec.version = version_components.compact.join(".")
  spec.authors = ["mrkn"]
  spec.email = ["mrkn@mrkn.jp"]

  spec.summary = %q{Plot your data by Unicode characters}
  spec.description = %q{Plot your data by Unicode characters}
  spec.homepage = "https://github.com/red-data-tools/unicode_plot.rb"
  spec.license = "MIT"

  spec.files = ["README.md", "Rakefile", "Gemfile", "#{spec.name}.gemspec"]
  spec.files << "LICENSE.txt"
  spec.files.concat Dir.glob("lib/**/*.rb")

  spec.test_files.concat Dir.glob("test/**/*.rb")

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) {|f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "enumerable-statistics", ">= 2.0.1"

  spec.add_development_dependency "bundler", ">= 1.17"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "test-unit"
end
