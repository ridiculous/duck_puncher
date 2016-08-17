require 'bundler/gem_tasks'
require 'rake'
require 'rake/testtask'

# Rake::TestTask.new(:soft_punch_test) do |t|
#   t.pattern = 'test/soft_punch/*_test.rb'
# end

Rake::TestTask.new(:hard_punch_test) do |t|
  t.pattern = 'test/lib/**/*_test.rb'
end

task default: [:hard_punch_test]
