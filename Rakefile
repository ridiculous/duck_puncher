require 'bundler/gem_tasks'
require 'rake'
require 'rake/testtask'

# Rake::TestTask.new(:soft_punch_test) do |t|
#   t.pattern = 'test/soft_punch/*_test.rb'
# end
root = Pathname.new File.expand_path('..', __FILE__)
tasks = []
Dir[root.join('test/lib/**/*_test.rb')].each do |file|
  tasks << Rake::TestTask.new(file.split('/').last[/\w+/].to_sym) do |t|
    t.pattern = file.sub(root.to_s + '/', '')
  end
end

task default: tasks.map(&:name)
