require 'rubygems'
require 'rspec/core/rake_task'

namespace :spec do
  desc "Run the tests for part 1"
  RSpec::Core::RakeTask.new(:part_1) do |t|
    t.pattern = 'spec/part_1/*_spec.rb'
  end

  desc "Run the tests for part 2"
  RSpec::Core::RakeTask.new(:part_2) do |t|
    t.pattern = 'spec/part_2/*_spec.rb'
  end

  desc "Run the tests for part 3"
  RSpec::Core::RakeTask.new(:part_3) do |t|
    t.pattern = 'spec/part_3/*_spec.rb'
  end
end
