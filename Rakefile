require 'bundler/gem_tasks'
require 'rake'
require 'rake/testtask'

root = Pathname.new File.expand_path('..', __FILE__)
tasks = []
Dir[root.join('test/lib/**/*_test.rb')].each do |file|
  tasks << Rake::TestTask.new(file.split('/').last[/\w+/].to_sym) do |t|
    t.pattern = file.sub(root.to_s + '/', '')
  end
end

task default: tasks.map(&:name)
