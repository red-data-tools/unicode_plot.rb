require "bundler/gem_helper"
require "yard"

base_dir = File.expand_path("..", __FILE__)
helper = Bundler::GemHelper.new(base_dir)
helper.install

desc "Run test"
task :test do
  ruby("test/run-test.rb")
end

task default: :test

YARD::Rake::YardocTask.new do |task|
end
