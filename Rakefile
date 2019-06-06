require "bundler/gem_helper"

base_dir = File.expand_path("..", __FILE__)
helper = Bundler::GemHelper.new(base_dir)
helper.install
spec = helper.gemspec

desc "Run test"
task :test do
  ruby("test/run-test.rb")
end

task default: :test
