require "rake"
require "rake/testtask"
require "bundler"

Bundler::GemHelper.install_tasks

desc "Run basic tests"
Rake::TestTask.new("test") do |t|
  t.libs << "test"
  t.pattern = "test/*_test.rb"
  t.verbose = true
  t.warning = true
end

desc "Lint Ruby"
task :lint do
  sh "bundle exec rubocop --format clang"
end

task default: %i[test lint]
